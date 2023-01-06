select m.COFICINA_ORIGEN,(SELECT O.NOMBRE FROM TOFICINAS O WHERE O.COFICINA=M.COFICINA_ORIGEN AND O.FHASTA>sysdate) AS NOM_OFICINA,
       '2022'as ejercicioeconomico,
       
       case when m.numerocomprobante like 'SP%' then ''
         else case when m.numerocomprobante like 'LP%' then ''
           else case when m.numerocomprobante like ' CT%' then ''
             else case when m.numerocomprobante like 'AN%' then ''
               else case when m.numerocomprobante like 'CS%' then ''
                 else case when m.numerocomprobante like 'R%' then ''
                   else case when m.numerocomprobante like 'CP%' then ''
                     else case when m.numerocomprobante like 'DS%' then ''
                       else case when m.numerocomprobante like 'CD%' then ''
                         else case when m.numerocomprobante like '09%' then ''
                         --else case when m.numerocomprobante is null then ''
         else
            (select c.ctipocomprobante from tcomprobantescontables c where c.fhasta > sysdate and c.numerocomprobante = m.numerocomprobante)
           end end end end end end end end end end tipocomprobante,
       
      --(select c.ctipocomprobante from tcomprobantescontables c where c.fhasta > sysdate and c.numerocomprobante = m.numerocomprobante)tipocomprobante,
        m.numerocomprobante, m.FCONTABLE,
       case when m.debitocredito = 'D' then  m.valormonedaoficial else  m.valormonedaoficial end totalcomprobante,
         --case when tt.debitocredito = 'D' then tt.valor else tt.valor end totalcomprobante,
       (case when csubsistema_origen='12' and ctransaccion_origen='3025' then
             (select t.descripcion from tconceptos t where t.cconcepto=m.cconcepto and t.fhasta>sysdate and t.cidioma='ES')
              else
              (select s.descripcion from tsubsistematransacciones s where s.fhasta > sysdate and s.csubsistema=m.csubsistema 
              and s.ctransaccion=m.ctransaccion_origen and s.versiontransaccion=01 and s.cidioma='ES')end)||' CtaRef. '||m.ccuenta as tipoasiento,
       
       m.codigocontable as codcuentacontable, 
       
       m.cgrupobalance,
       m.ctransaccion_origen,
       (SELECT f.NOMBRECUENTA from tcuentacontable f where f.codigocontable=m.codigocontable and f.fhasta>sysdate) AS descripcioncuentacontable,
       case when m.debitocredito = 'D' then m.valormonedaoficial else 0 end as debe, --debito debe
       case when m.debitocredito = 'C' then m.valormonedaoficial else 0 end as haber, --credito haber
         M.DEBITOCREDITO,
       
       (select p.nombrelegal from tpersona p where p.fhasta > sysdate and p.cpersona = m.cpersona_cliente)beneficiario,

        'si' as controlmayorizado,
(select estructuracodigo from tcatalogocuentas where codigocontable=m.codigocontable and fhasta>sysdate)estructuracodigo,

      m.CUSUARIO,
m.CSUCURSAL_ORIGEN ,
(select r.nombre from tsucursales r where r.csucursal=m.CSUCURSAL_ORIGEN and r.fhasta>sysdate) AS NOM_SUCURSAL

from tmovimientos m
where m.fcontable  between TRUNC(TO_DATE('&fecha','dd-mm-yyyy')) and TRUNC(TO_DATE('&fecha1','dd-mm-yyyy'))
AND m.valormonedaoficial<>0
and m.ccuenta='642000003337-1'
and m.CATEGORIA IN ('CXC44','CXC36','CXC40','CXC42','CXC39','CXC49','CXC45','CXC38','CXC41','CXC47','CXC48','CXC5')
--and m.codigocontable = '16143005'
--and m.numerocomprobante = '10721000004'
--AND M.CSUCURSAL_ORIGEN LIKE $P{Sucursal}
--AND M.COFICINA_ORIGEN LIKE $P{Oficina}
order by m.freal, m.numerocomprobante,m.CSUCURSAL_ORIGEN, m.coficina_origen, m.STRANSACCION
