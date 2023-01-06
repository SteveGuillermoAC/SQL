select 
tm.fcontable FECHA,
tm.stransaccion,
tp.identificacion,
tp.nombrelegal,
tc.ccuenta OPERACION,
tof.coficina COFICINA,
tof.nombre AGENCIA,
tm.valormonedaoficial VALOR,
tm.cgrupobalance,
tm.debitocredito

FROM
/*(select case when (select count(saldomonedacuenta)
        from tsaldos
        where ccuenta =tm.ccuenta)>0 then 'COBRADO') ELSE 'NO COBRADO'
        END ,*/
TMOVIMIENTOS tm inner join tcuenta tc
on tc.ccuenta=tm.ccuenta
and tm.cproducto=tc.cproducto
join tpersona tp
on tp.cpersona=tc.cpersona_cliente
 join toficinas tof
on tof.coficina=tc.coficina
join tcategorias tcat 
on tcat.categoria =tm.categoria
join testatuscuenta tec 
on tec.cestatuscuenta = tc.cestatuscuenta
join tclasificacioncontable tcc 
on tcc.cclasificacioncontable = tm.cclasificacioncontable
where tm.csubsistema_transaccion=tc.csubsistema
and tc.fhasta=fncfhasta and tof.fhasta=fncfhasta
and tp.fhasta=fncfhasta
AND tm.CTRANSACCION_ORIGEN IN ('2004', '3073', '3026','2000')
--and tm.fcontable = to_date('16-09-2022','dd-mm-yyyy')
and tm.ccuenta='642000003337-1'
AND tm.CATEGORIA IN ('CXC44','CXC36','CXC40','CXC42','CXC39','CXC49','CXC45','CXC38','CXC41','CXC47','CXC48','CXC5')
and tm.fcontable<sysdate
and tm.reverso=0
and tm.cusuario <> '1'
and tcc.csubsistema in ('06')
AND TM.CSUBSISTEMA in ('06')
and tc.csubsistema = tec.csubsistema
--and tm.cgrupobalance=2
and tcat.cgrupobalance=2
group by tm.fcontable ,
tm.stransaccion,
tp.identificacion,
tp.nombrelegal,
tc.ccuenta,
tof.nombre,tof.coficina,
tm.valormonedaoficial,
tm.cgrupobalance,
tm.debitocredito
