create or replace view view_einvoice_tran
(data_type, entity_code, tcode, vrno, vrdate, acc_code, entity_acc_code, broker_code, consignee_code, trpt_code, truckno, challanno, challandate, partybillno, partybilldate, from_place, to_place, delivery_from_slno, delivery_to_slno, entity_add_slno, acc_add_slno, consignee_address_slno, div_code, item_code, gst_um_name, gst_um, um, slno, qtyissued, afield1, partyqty, dramt, cramt, waybillno, waybill_date, tax_code, tax_rate1, tax_rate, fc_rate, rate, sgst_rate, cgst_rate, igst_rate, cess_rate, tax_onamount, item_name, item_group, sgst_amount, cgst_amount, igst_amount, cess_amount, gst_code, stax_code, codefor, lrno, currency_code, exchange_rate, lrdate, vehicle_type, tnature, series, bheading, item_catg, cess_rate_per, cess_non_advol_amount, trantype, partyrefno, partyrefdate, item_detail, batchno, gst_einvoice_group, dispatch_from_slno)
as
with lu as (select case when instr(parameter_value,'#',1,1)=0 then
                        upper(parameter_value)
                        when instr(parameter_value,'#',1,1)<>0 then
                        substr(parameter_value,1,instr(parameter_value,'#',1,1)-1)
                   else
                        null
                   end einvoice_item_group,
                   case when instr(parameter_value,'#',1,1)<>0 then
                        substr(substr(parameter_value,instr(parameter_value,'#',1,1)+1),instr(substr(parameter_value,instr(parameter_value,'#',1,1)+1),'~',1,1)+1)
                   else
                        null
                   end batchno_required
            from   lhssys_parameters
            where  parameter_name='EINVOICE_ITEM_GROUP'
            /*
            parameter_value should be
            GST_CODE : GST code wise
            ITEM_CODE : Item code wise
            PARENT_CODE : Parent code wise
            ITEM_SCH : Item schedule wise
            ITEM_GROUP : Item group wise
            ITEM_CLASS : Item class wise
            ITEM_CATG : Item category wise
            ITEM_REMARK : Item Remark (Transaction)
            */
           )
select a.data_type,
       a.entity_code,
       a.tcode,
       a.vrno,
       a.vrdate,
       a.acc_code,
       a.entity_acc_code,
       a.broker_code,
       a.consignee_code,
       a.trpt_code,
       a.truckno,
       a.challanno,
       a.challandate,
       a.partybillno,
       a.partybilldate,
       a.from_place,
       a.to_place,
       a.delivery_from_slno,
       a.delivery_to_slno,
       a.entity_add_slno,
       a.acc_add_slno,
       a.consignee_address_slno,
       a.div_code,
       a.item_code,
       a.gst_um_name,
       a.gst_um,
       a.um,
       a.slno,
       a.qtyissued,
       a.afield1,
       a.partyqty,
       a.dramt ,
       a.cramt,
       a.waybillno,
       a.waybill_date,
       a.tax_code,
       a.tax_rate1,
       a.tax_rate,
       a.fc_rate,
       a.rate,
       a.sgst_rate,
       a.cgst_rate,
       a.igst_rate,
       /*case when nvl(a.cess_amount,0)>0 and nvl(a.tax_onamount,0)>0 then
            round((nvl(a.cess_amount,0)/nvl(a.tax_onamount,0)*100),3)
       else
           a.cess_rate
       end*/ A.cess_rate,
       a.tax_onamount,
       a.item_name,
       a.item_group,
       a.sgst_amount,
       a.cgst_amount,
       a.igst_amount,
       a.cess_amount,
       a.gst_code,
       a.stax_code,
       a.codefor,
       a.lrno,
       a.currency_code,
       a.exchange_rate,
       a.lrdate,
       a.vehicle_type,
       a.tnature,
       a.series,
       a.bheading,
       a.item_catg,
       a.cess_rate_per,
       a.cess_non_advol_amount,
       a.trantype,
       a.partyrefno,
       a.partyrefdate,
       a.item_detail,
       a.batchno,
       a.gst_einvoice_group,
       nvl(a.dispatch_from_slno,entity_add_slno) dispatch_from_slno
from   (select 'ITEMTRAN' data_type,
               a.entity_code,
               a.tcode,
               a.vrno,
               a.vrdate,
               a.acc_code,
               em.acc_code entity_acc_code,
               a.broker_code,
               a.consignee_code,
               a.trpt_code,
               a.truckno,
               a.challanno,
               a.challandate,
               rpad(' ',50,' ') partybillno, --Please donot change the value of this column
               null partybilldate, --Please donot change the value of this column
              -- a.currency_code,
               a.from_place,
               a.to_place,
               case when c.tnature='SCRNT' then
                    a.delivery_to_slno
               else
                   a.delivery_from_slno
               end delivery_from_slno,
               case when c.tnature='SCRNT' then
                    a.delivery_from_slno
               else
                   a.delivery_to_slno
               end delivery_to_slno,
               case when c.tnature in ('SCRNT',/*'PRET',*/'SRET','SREV') then
                    a.delivery_to_slno
               else
                    a.delivery_from_slno
               end  entity_add_slno,
               case when c.tnature in ('SCRNT',/*'PRET',*/'SRET','SREV') then
                    a.delivery_from_slno
               else
                    a.delivery_to_slno
               end  acc_add_slno,
               a.consignee_address_slno,
               b.div_code,
               b.item_code,
               case when (b.um=b.rate_um or b.rate_um is null) then
                    (select um.gst_um_name from um_mast um where um.um_code=b.um)
               else
                    (select um.gst_um_name from um_mast um where um.um_code=b.aum)
               end gst_um_name,
               case when b.um=b.rate_um or b.rate_um is null then
                    b.um
               else
                    b.aum
               end gst_um,
               case when b.um=b.rate_um or b.rate_um is null then
                    b.um
               else
                    b.aum
               end um,
               b.slno,
               case when (b.um=b.rate_um or rate_um is null) then
                    (nvl(b.qtyissued,0)+nvl(b.qtyrecd,0))
               else
                    (nvl(b.aqtyissued,0)+nvl(b.aqtyrecd,0))
               end qtyissued,
               round(b.afield1,2) afield1,
               b.partyqty,
               round(nvl(b.dramt,0),2) dramt ,
               round(nvl(b.cramt,0),2) cramt,
               waybillno,
               waybill_date,
               b.tax_code,
               b.tax_rate1,
               b.tax_rate,
               b.fc_rate,
               case when b.um=b.rate_um or b.rate_um is null then
                    round(b.rate,3)
               else
                    round(b.arate,3)
               end rate,
               (case when codefor in ('T','8','H','J')  then tax_rate end)  sgst_rate,
               (case when codefor in ('T','8','H','J')  then tax_rate1 end)  cgst_rate,
               (case when codefor in ('K','5','I','9','M','P','Q') then  tax_rate1  end) igst_rate,
             /*  tax_rate2*/NULL cess_rate,
               round(b.tax_onamount,2) tax_onamount,
               im.item_name,
               im.item_group,
               case when m.codefor in ('T','8','H','J') then
                    b.tax_amount
               else
                    0
               end sgst_amount,
               case when m.codefor in ('T','8','H','J') then
                    round(b.tax_amount1,2)
               else
                    0
               end cgst_amount,
               case when m.codefor in ('K','5','I','9','M','P','Q') then
                    round(b.tax_amount1,2)
               else
                    0
               end igst_amount,
               /*round(b.tax_amount2,2)*/NULL cess_amount,
               nvl(b.gst_code,im.gst_code) gst_code,
               a.stax_code,
               m.codefor,
               a.lrno,
               a.currency_code,
               a.exchange_rate,
               a.lrdate,
               a.vehicle_type,
               c.tnature,
               c.series,
               c.bheading,
               im.item_catg,
            /*   null cess_rate_per,
               null cess_non_advol_amount,*/
                 b.tax_rate2  cess_rate_per,
               round(b.tax_amount2,2) cess_non_advol_amount,
               a.trantype,
              '' partyrefno,
              '' partyrefdate,
              im.item_detail,
              case when upper(nvl(lu.batchno_required,'N'))='N' then
                   'N.A.'
              else
                   b.batchno
              end batchno,
              case when lu.einvoice_item_group='GST_CODE' then
                    nvl(b.gst_code,im.gst_code)
                    when lu.einvoice_item_group='ITEM_CODE' then
                    b.item_code
                    when lu.einvoice_item_group='PARENT_CODE' then
                    im.parent_code
                    when lu.einvoice_item_group='ITEM_SCH' then
                    im.item_Sch
                    when lu.einvoice_item_group='ITEM_GROUP' then
                    im.item_group
                    when lu.einvoice_item_group='ITEM_CLASS' then
                    im.item_class
                    when lu.einvoice_item_group='ITEM_CATG' then
                    im.item_catg
                    when lu.einvoice_item_group='ITEM_REMARK' then
                     substr(b.remark,1,300)
                    when lu.einvoice_item_group='ITEM_DETAIL' then
                     substr(NVL(IM.ITEM_DETAIL,IM.ITEM_NAME),1,300)
               else
                    null
               end gst_einvoice_group,
               --(select slno from address_mast a1, area_mast b1 where a1.slno=b1.addon_code and b1.area_code=a.from_place) dispatch_from_slno
               (select slno from address_mast a1, area_mast b1 where INSTR(b1.addon_code||',',A1.SLNO||',')>0  and b1.area_code=a.from_place
              AND ACC_CODE=EM.ACC_CODE) dispatch_from_slno
        from   itemtran_head a,
               itemtran_body b,
               config_mast c,
               stax_mast m,
               item_mast im,
               entity_mast em,
               lu
        where  c.entity_code=a.entity_code
        and    c.tcode=a.tcode
        and    c.series || substr(c.acc_year, 1, 2)=substr(a.vrno, 1, 4)
        and    c.tnature in ('SALE','SDRNT','SCRNT','CBIL','CHLN','PRET','REVN','SRET','SREV','TSALE','PCRNT','PDRNT')
        and    a.entity_code = b.entity_code
        and    a.tcode = b.tcode
        and    a.vrno = b.vrno
        and    em.entity_code=a.entity_code
        and    m.stax_code(+)=a.stax_code
        and    im.item_code=b.item_code
       ) a

