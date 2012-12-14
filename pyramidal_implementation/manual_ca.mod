COMMENT


Mod file auto-generated by pyramidal on 2012-12-13 16:01:49.187821 and Modified by Mike Vella


ENDCOMMENT


NEURON {
    SUFFIX ca
    USEION ca READ eca WRITE ica
    RANGE gbar
    RANGE gca
    RANGE m
    RANGE m_A_A,m_A_B,m_A_C,m_A_D,m_A_F
    RANGE m_B_A,m_B_B,m_B_C,m_B_D,m_B_F
    RANGE minf, mtau
    RANGE h
    RANGE h_A_A,h_A_B,h_A_C,h_A_D,h_A_F
    RANGE h_B_A,h_B_B,h_B_C,h_B_D,h_B_F
    RANGE hinf, htau
    GLOBAL ca_reversal_potential
    GLOBAL vmin, vmax
}




PARAMETER {
    m_A_A    = 0.017676003723    (mV)
    m_A_B    = -0.000707040148919    (ms)
    m_A_C    = -1.0    (mV)
    m_A_D    = -25.0    (mV)
    m_A_F    = -10.0    (mV)
    m_B_A    = 0.0282816059568    (mV)
    m_B_B    = 0.0    (mV)
    m_B_C    = 0.0        
    m_B_D    = 0.0    (mV)
    m_B_F    = 18.0    (mV)
    h_A_A    = 0.000494928104243    (mV)
    h_A_B    = 0.0    (ms)
    h_A_C    = 0.0    (mV)
    h_A_D    = 0.0    (mV)
    h_A_F    = 115.168929654    (mV)
    h_B_A    = 0.00707040148919    (mV)
    h_B_B    = 0.0    (mV)
    h_B_C    = 1.0        
    h_B_D    = -30.0    (mV)
    h_B_F    = -10.0    (mV)
    gbar     = 659646.836047      (pS/um2)
    ca_reversal_potential = 20.0    (mV)
    v                                 (mV)
    dt                                (ms)
    vmin     = -30    (mV)
    vmax     = 120    (mV)
}




UNITS {
     (mA) = (milliamp)
     (mV) = (millivolt)
     (pS) = (picosiemens)
     (um) = (micron)
}




ASSIGNED {
    ica    (mA/cm2)
    gca    (pS/um2)
    eca    (mV)
    minf
    mtau (ms)
    hinf
    htau (ms)
}




STATE { m h }




INITIAL {
    trates(v)
    m = minf
    h = hinf
}




BREAKPOINT {
    SOLVE states METHOD cnexp
    gca = gbar*m*m*m*h
    ica = (1e-4) * gca * (v - ca_reversal_potential)
}




LOCAL mexp
LOCAL hexp




DERIVATIVE states {
    trates(v)
    m' =  (minf-m)/mtau
    h' =  (hinf-h)/htau
}




PROCEDURE trates(v) {
    TABLE minf, mtau, hinf, htau
    FROM vmin TO vmax WITH 199
    rates(v): not consistently executed from here if usetable == 1
}




PROCEDURE rates(vm) {
    LOCAL  a, b
    a = trap0(vm,m_A_A,m_A_B,m_A_C,m_A_D,m_A_F)
    b = trap0(vm,m_B_A,m_B_B,m_B_C,m_B_D,m_B_F)
    mtau = 1/(a+b)
    minf = a/(a+b)
    a = trap0(vm,h_A_A,h_A_B,h_A_C,h_A_D,h_A_F)
    b = trap0(vm,h_B_A,h_B_B,h_B_C,h_B_D,h_B_F)
    htau = 1/(a+b)
    hinf = a/(a+b)
}




FUNCTION trap0(v,A,B,C,D,F) {
	if (fabs(v/A) > 1e-6) {
	        trap0 = (A + B * v) / (C + exp((v + D)/F))
	} else {
	        trap0 = B * F
 	}
}

