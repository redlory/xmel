<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:lookup="https://github.com/redlory/xmel/lookup">
<xsl:output method="html"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

<xsl:template match="text()">
</xsl:template>

<xsl:template match="/Файл">
    <xsl:variable name="Form">
        <xsl:choose>
            <xsl:when test="ФормаОтч/@НомФорм='5-о'">05</xsl:when>
            <xsl:when test="ФормаОтч/@НомФорм='6-о'">06</xsl:when>
            <xsl:when test="ФормаОтч/@НомФорм='7-о'">07</xsl:when>
            <xsl:when test="ФормаОтч/@НомФорм='8-о'">08</xsl:when>
            <xsl:otherwise><xsl:value-of select="ФормаОтч/@НомФорм"/></xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
<html>
<head>
<title>Декларация</title>
<xsl:call-template name="CSS"/>
</head>
<body>
<h1>
    <xsl:call-template name="Lookup">
        <xsl:with-param name="table">Title</xsl:with-param>
        <xsl:with-param name="key" select="$Form"/>
    </xsl:call-template>
</h1>

<table class="form">
<tr><th>Версия формата:</th>
<td><xsl:value-of select="@ВерсФорм"/></td>
</tr>
<tr><th>Передающая программа:</th>
<td><xsl:value-of select="@НаимПрог"/></td>
</tr>
<tr><th>Дата:</th>
<td><xsl:value-of select="@ДатаДок"/></td>
</tr>
<tr><th>Период:</th>
<td>
    <xsl:choose>
        <xsl:when test='ФормаОтч/@ПризПериодОтч="3"'>1</xsl:when>
        <xsl:when test='ФормаОтч/@ПризПериодОтч="6"'>2</xsl:when>
        <xsl:when test='ФормаОтч/@ПризПериодОтч="9"'>3</xsl:when>
        <xsl:when test='ФормаОтч/@ПризПериодОтч="0"'>4</xsl:when>
    </xsl:choose>
    квартал <xsl:value-of select="ФормаОтч/@ГодПериодОтч"/> года
</td>
</tr>
<tr><th>Форма отчетности:</th>
<td>
    <xsl:choose>
	<xsl:when test="ФормаОтч/Первичная">первичная</xsl:when>
	<xsl:when test="ФормаОтч/Корректирующая">корректирующая</xsl:when>
    </xsl:choose>
</td>
</tr>

<xsl:if test="ФормаОтч/Корректирующая/@НомерКорр">
    <tr><th>Номер корректировки:</th>
    <td>
        <xsl:value-of select="ФормаОтч/Корректирующая/@НомерКорр"/>
    </td>
    </tr>
</xsl:if>
<xsl:if test="ФормаОтч/@ПризФОтч">
    <tr><th>Признак формы отчетности:</th>
    <td>
        <xsl:variable name="ПризФОтч" select="ФормаОтч/@ПризФОтч"/>
        <xsl:value-of select="$ПризФОтч"/> - 
        <xsl:choose>
            <xsl:when test='$ПризФОтч=1'>для вида деятельности производство, хранение и поставки произведенного этилового спирта питьевого (относится к алкогольной продукции, для районов Крайнего Севера)</xsl:when>
            <xsl:when test='$ПризФОтч=2'>для вида деятельности производство, хранение и поставки произведенных спиртных напитков</xsl:when>
            <xsl:when test='$ПризФОтч=3'>для производства, хранения и поставки произведенных вин</xsl:when>
            <xsl:when test='$ПризФОтч=4'>для другого вида деятельности</xsl:when>
        </xsl:choose>
    </td>
    </tr>
</xsl:if>
<tr><th>Организация:</th>
<td>
    <xsl:value-of select="Документ/Организация/Реквизиты/@НаимЮЛ|Документ/Организация/Реквизиты/@НаимОрг"/>
</td>
</tr>
<tr><th>ИНН:</th>
<td>
    <xsl:value-of select="Документ/Организация/Реквизиты/@ИННЮЛ|Документ/Организация/Реквизиты/ЮЛ/@ИННЮЛ"/>
</td>
</tr>
<tr><th>КПП:</th>
<td>
    <xsl:value-of select="Документ/Организация/Реквизиты/@КППЮЛ|Документ/Организация/Реквизиты/ЮЛ/@КППЮЛ"/>
</td>
</tr>
<tr><th>Телефон:</th>
<td>
    <xsl:value-of select="Документ/Организация/Реквизиты/@ТелОрг"/>
</td>
</tr>
<tr><th>e-mail:</th>
<td>
    <xsl:value-of select="Документ/Организация/Реквизиты/@EmailОтпр"/>
</td>
</tr>
<tr><th>Адрес:</th>
<td>
    <xsl:apply-templates select="Документ/Организация/Реквизиты/АдрОрг"/>
</td>
</tr>
<tr><th>Руководитель:</th>
<td>
    <xsl:value-of select="Документ/Организация/ОтветЛицо/Руководитель"/>
</td>
</tr>
<tr><th>Гл. бухгалтер:</th>
<td>
    <xsl:value-of select="Документ/Организация/ОтветЛицо/Главбух"/>
</td>
</tr>
</table>

<h2>Лицензии</h2>
<table>
<xsl:choose>
<xsl:when test="@ВерсФорм='4.20'">
    <tr><th>Вид деятельности</th><th>Серия</th><th>Номер</th><th>Дата начала</th><th>Дата окончания</th></tr>
    <xsl:for-each select="Документ/Организация/Лицензии/Лицензия">
        <tr>
        <td>
            <xsl:call-template name="Lookup">
                <xsl:with-param name="table">BisnessType4.20</xsl:with-param>
                <xsl:with-param name="key" select="@ВидДеят"/>
            </xsl:call-template>
        </td>
        <td><xsl:value-of select="@СерЛиц"/></td>
        <td><xsl:value-of select="@НомерЛиц"/></td>
        <td><xsl:value-of select="@ДатаНачЛиц"/></td>
        <td><xsl:value-of select="@ДатаОконЛиц"/></td>
        </tr>
    </xsl:for-each>
</xsl:when>
<xsl:otherwise>
    <tr><th>Вид деятельности</th><th>Серия и номер</th><th>Дата начала</th><th>Дата окончания</th></tr>
    <xsl:for-each select="Документ/Организация/Деятельность/Лицензируемая/Лицензия">
        <tr>
        <td>
            <xsl:call-template name="Lookup">
                <xsl:with-param name="table">BisnessType4.30</xsl:with-param>
                <xsl:with-param name="key" select="@ВидДеят"/>
            </xsl:call-template>
        </td>
        <td><xsl:value-of select="@СерНомЛиц"/></td>
        <td><xsl:value-of select="@ДатаНачЛиц"/></td>
        <td><xsl:value-of select="@ДатаОконЛиц"/></td>
        </tr>
    </xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</table>

<xsl:choose>

    <xsl:when test="$Form='05'">
        <h2>Оборот</h2>
        <xsl:call-template name="Оборот"/>
    </xsl:when>

    <xsl:when test="$Form='06'">
        <h2>Поставки</h2>
        <xsl:call-template name="ПоставкиЗакупки">
            <xsl:with-param name="report">Поставка</xsl:with-param>
            <xsl:with-param name="part">Поставка</xsl:with-param>
        </xsl:call-template>
        <h2>Возвраты</h2>
        <xsl:call-template name="ПоставкиЗакупки">
            <xsl:with-param name="report">Поставка</xsl:with-param>
            <xsl:with-param name="part">Возврат</xsl:with-param>
        </xsl:call-template>
    </xsl:when>

    <xsl:when test="$Form='07'">
        <h2>Закупки</h2>
        <xsl:call-template name="ПоставкиЗакупки">
            <xsl:with-param name="report">Закупка</xsl:with-param>
            <xsl:with-param name="part">Закупка</xsl:with-param>
        </xsl:call-template>
        <h2>Возвраты</h2>
        <xsl:call-template name="ПоставкиЗакупки">
            <xsl:with-param name="report">Закупка</xsl:with-param>
            <xsl:with-param name="part">Возврат</xsl:with-param>
        </xsl:call-template>
    </xsl:when>

    <xsl:when test="$Form='08'">
        <h2>Перевозки</h2>
        <xsl:call-template name="Перевозки"/>
    </xsl:when>

</xsl:choose>

</body>
</html>
</xsl:template>

<!-- ==================== Форма 5 - Оборот ================================ -->

<xsl:template name="Оборот">
    <table class="data">
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col class="balance"/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col/>
    <col class="balance"/>
    <tr>
    <th rowspan="4">№ п/п</th>
    <th rowspan="4">Вид продукции</th>
    <th rowspan="4">Код вида продукции</th>
    <th colspan="3">Сведения о производителе / импортере</th>
    <th rowspan="4">Остаток на начало отчетного периода</th>
    <th colspan="8">Поступления</th>
    <th colspan="8">Расход</th>
    <th rowspan="4">Остаток на конец отчетного периода</th>
    </tr>
    <tr>
    <th rowspan="3">наименование производителя/импортера</th>
    <th rowspan="3">ИНН</th>
    <th rowspan="3">КПП</th>
    <th colspan="4">закупки</th>
    <th rowspan="3">возврат продукции</th>
    <th rowspan="3">прочие поступления</th>
    <th rowspan="3">перемещение внутри одной организации</th>
    <th rowspan="3">всего</th>
    <th colspan="4">поставки</th>
    <th rowspan="3">прочий расход</th>
    <th rowspan="3">возврат поставщикам</th>
    <th rowspan="3">перемещение внутри одной организации</th>
    <th rowspan="3">всего</th>
    </tr>
    <tr>
    <th colspan="3">в том числе</th>
    <th rowspan="2">итого</th>
    <th colspan="3">в том числе</th>
    <th rowspan="2">итого</th>
    </tr>
    <tr>
    <th>от организаций-производителей</th>
    <th>от организаций оптовой торговли</th>
    <th>по импорту</th>
    <th>организациям оптовой торговли</th>
    <th>организациям розничной торговли</th>
    <th>на экспорт</th>
    </tr>
    <xsl:for-each select="Документ/ОбъемОборота">
        <xsl:call-template name="ОборотПодразделения"/>
    </xsl:for-each>
    </table>
</xsl:template>
    
<xsl:template name="ОборотПодразделения">
    <tr class="div">
    <td></td>
    <th colspan="6">По подразделению:</th>
    <td colspan="17">
        <xsl:value-of select="@НаимЮЛ"/>,
        КПП: <xsl:value-of select="@КППЮЛ"/>.
        <xsl:apply-templates select="АдрОрг"/>
    </td>
    </tr>
    <xsl:for-each select="Оборот/СведПроизвИмпорт">
        <xsl:call-template name="ОборотПроизводитель"/>
    </xsl:for-each>
 
    <tr class="sum">
    <td></td>
    <td colspan="5">Итого:</td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000007)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000008)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000009)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000010)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000011)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000012)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000013)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000014)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000015)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000016)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000017)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000018)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000019)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000020)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000021)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000022)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000023)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/@П000000000024)*100000) div 100000"/></td>
    </tr>
</xsl:template>

<xsl:template name="ОборотПроизводитель">
    <tr>
    <td class="num">
        <xsl:number level="any" from="ОбъемОборота" count="СведПроизвИмпорт"/>
    </td>
    <xsl:apply-templates select="../@П000000000003"/>
    <td><xsl:value-of select="@П000000000004"/></td>
    <td><xsl:value-of select="@П000000000005"/></td>
    <td><xsl:value-of select="@П000000000006"/></td>
    <td class="num"><xsl:value-of select="@П000000000007"/></td>
    <td class="num"><xsl:value-of select="@П000000000008"/></td>
    <td class="num"><xsl:value-of select="@П000000000009"/></td>
    <td class="num"><xsl:value-of select="@П000000000010"/></td>
    <td class="sum"><xsl:value-of select="@П000000000011"/></td>
    <td class="num"><xsl:value-of select="@П000000000012"/></td>
    <td class="num"><xsl:value-of select="@П000000000013"/></td>
    <td class="num"><xsl:value-of select="@П000000000014"/></td>
    <td class="sum"><xsl:value-of select="@П000000000015"/></td>
    <td class="num"><xsl:value-of select="@П000000000016"/></td>
    <td class="num"><xsl:value-of select="@П000000000017"/></td>
    <td class="num"><xsl:value-of select="@П000000000018"/></td>
    <td class="sum"><xsl:value-of select="@П000000000019"/></td>
    <td class="num"><xsl:value-of select="@П000000000020"/></td>
    <td class="num"><xsl:value-of select="@П000000000021"/></td>
    <td class="num"><xsl:value-of select="@П000000000022"/></td>
    <td class="sum"><xsl:value-of select="@П000000000023"/></td>
    <td class="num"><xsl:value-of select="@П000000000024"/></td>
    </tr>
</xsl:template>

<!-- ================== Форма 6,7 - Поставки, закупки ====================== -->

<xsl:template name="ПоставкиЗакупки">
    <xsl:param name="report"/>
    <xsl:param name="part"/>
    <table class="data">
    <xsl:choose>
    <xsl:when test="$report='Поставка'">
        <tr>
        <th rowspan="3">№ п/п</th>
        <th rowspan="3">Вид продукции</th>
        <th rowspan="3">Код вида продукции</th>
        <th colspan="3">Сведения о производителе / импортере</th>
        <th colspan="8">Сведения о получателе</th>
        <th colspan="3">Уведомление о поставке</th>
        <th rowspan="3">Дата поставки</th>
        <th rowspan="3">Номер товарно-транспортной накладной</th>
        <th rowspan="3">Номер таможенной декларации</th>
        <th rowspan="3">Объем поставленной продукции</th>
        </tr>
        <tr>
        <th rowspan="2">Наименование производителя/импортера</th>
        <th rowspan="2">ИНН</th>
        <th rowspan="2">КПП</th>
        <th rowspan="2">наименование организации</th>
        <th rowspan="2">место нахождения</th>
        <th rowspan="2">ИНН</th>
        <th rowspan="2">КПП</th>
        <th colspan="4">лицензия</th>
        <th rowspan="2">дата</th>
        <th rowspan="2">номер</th>
        <th rowspan="2">объем поставки</th>
        </tr>
        <tr>
        <th>серия, номер</th>
        <th>дата выдачи</th>
        <th>дата окончания</th>
        <th>кем выдана</th>
        </tr>
    </xsl:when>
    <xsl:otherwise>
        <tr>
        <th rowspan="3">№ п/п</th>
        <th rowspan="3">Вид продукции</th>
        <th rowspan="3">Код вида продукции</th>
        <th colspan="3">Сведения о производителе / импортере</th>
        <th colspan="8">Сведения о поставщике</th>
        <th colspan="3">Уведомление о закупке</th>
        <th rowspan="3">Дата закупки (дата отгрузки поставщиком)</th>
        <th rowspan="3">Номер товарно-транспортной накладной</th>
        <th rowspan="3">Номер таможенной декларации</th>
        <th rowspan="3">Объем закупленной продукции</th>
        </tr>
        <tr>
        <th rowspan="2">Наименование производителя/импортера</th>
        <th rowspan="2">ИНН</th>
        <th rowspan="2">КПП</th>
        <th rowspan="2">наименование организации</th>
        <th rowspan="2">место нахождения</th>
        <th rowspan="2">ИНН</th>
        <th rowspan="2">КПП</th>
        <th colspan="4">лицензия</th>
        <th rowspan="2">дата</th>
        <th rowspan="2">номер</th>
        <th rowspan="2">объем закупки</th>
        </tr>
        <tr>
        <th>серия, номер</th>
        <th>дата выдачи</th>
        <th>дата окончания</th>
        <th>кем выдана</th>
        </tr>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:for-each select="Документ/ОбъемОборота[
                @НаличиеПоставки='true' and $part='Поставка' 
                or @НаличиеЗакупки='true' and $part='Закупка' 
                or @НаличиеВозврата='true' and $part='Возврат']">
        <xsl:call-template name="ПоставкиЗакупкиПодразделения">
            <xsl:with-param name="report" select="$report"/>
            <xsl:with-param name="part" select="$part"/>
        </xsl:call-template>
    </xsl:for-each>
    </table>
</xsl:template>

<xsl:template name="ПоставкиЗакупкиПодразделения">
    <xsl:param name="report"/>
    <xsl:param name="part"/>
    <tr class="div">
    <td></td>
    <th colspan="5">По подразделению:</th>
    <td colspan="15">
        <xsl:value-of select="@НаимЮЛ"/>,
        КПП: <xsl:value-of select="@КППЮЛ"/>.
        <xsl:apply-templates select="АдрОрг"/>
    </td>
    </tr>
    <xsl:variable name="contractor"><xsl:choose>
        <xsl:when test="$report='Поставка'">Получатель</xsl:when>
        <xsl:when test="$report='Закупка'">Поставщик</xsl:when>
    </xsl:choose></xsl:variable>
    <xsl:for-each select="Оборот/СведПроизвИмпорт/*[local-name()=$contractor]/*[local-name()=$part]">
        <xsl:call-template name="ПоставкиЗакупкиСтрока">
            <xsl:with-param name="report" select="$report"/>
            <xsl:with-param name="part" select="$part"/>
        </xsl:call-template>
    </xsl:for-each>

    <tr class="sum">
    <td></td>
    <td colspan="15">Итого:</td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/*[local-name()=$contractor]/*[local-name()=$part]/@П000000000017)*100000) div 100000"/></td>
    <td colspan="3"></td>
    <td class="num"><xsl:value-of select="round(sum(Оборот/СведПроизвИмпорт/*[local-name()=$contractor]/*[local-name()=$part]/@П000000000021)*100000) div 100000"/></td>
    </tr>
</xsl:template>

<xsl:template name="ПоставкиЗакупкиСтрока">
    <xsl:param name="report"/>
    <xsl:param name="part"/>
    <tr>
    <td>
        <xsl:choose>
            <xsl:when test="$part='Поставка'"><xsl:number level="any" from="ОбъемОборота" count="Поставка"/></xsl:when>
            <xsl:when test="$part='Закупка'" ><xsl:number level="any" from="ОбъемОборота" count="Закупка"/></xsl:when>
            <xsl:when test="$part='Возврат'" ><xsl:number level="any" from="ОбъемОборота" count="Возврат"/></xsl:when>
        </xsl:choose>
    </td>
    <xsl:apply-templates select="../../../@П000000000003"/>
    <xsl:apply-templates select="../../@ИдПроизвИмп"/>
    <xsl:apply-templates select="../@ИдПолучателя|../@ИдПоставщика"/>
    <xsl:choose>
        <xsl:when test="../@ИдЛицензии"><xsl:apply-templates select="../@ИдЛицензии"/></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="document('')//lookup:empty/Лицензия"/></xsl:otherwise>
    </xsl:choose>
    <td><xsl:value-of select="@П000000000015"/></td>
    <td><xsl:value-of select="@П000000000016"/></td>
    <td class="num"><xsl:value-of select="@П000000000017"/></td>
    <td><xsl:value-of select="@П000000000018"/></td>
    <td><xsl:value-of select="@П000000000019"/></td>
    <td><xsl:value-of select="@П000000000020"/></td>
    <td class="num"><xsl:value-of select="@П000000000021"/></td>
    </tr>
</xsl:template>

<!-- i================== Форма 8  Перевозки ================================ -->

<xsl:template name="Перевозки">
    <table class="data">
    <tr>
    <th rowspan="3">№ п/п</th>
    <th rowspan="3">Вид перевозки</th>
    <th rowspan="3">Вид продукции</th>
    <th colspan="9">Сведения о перевозчике</th>
    <th colspan="3">Сведения о транспортном средстве</th>
    <th colspan="3">Сведения, содержащиеся в грузовой транспортной накладной (ТН) перевозчика</th>
    <th colspan="6">Сведения, содержащиеся в товарно-транспортной накладной (ТТН) грузоотправителя</th>
    <th rowspan="3">Объем перевозимой продукции (декалитров)</th>
    </tr>
    <tr>
    <th colspan="3">организация</th>
    <th colspan="2">индивидуальный предприниматель</th>
    <th colspan="4">сведения о лицензии</th>
    <th rowspan="2">тип</th>
    <th rowspan="2">грузоподъемность (т)</th>
    <th rowspan="2">регистрационный номер</th>
    <th rowspan="2">дата ТН</th>
    <th rowspan="2">номер ТН</th>
    <th rowspan="2">масса груза (брутто), (т)/(дал)</th>
    <th rowspan="2">Дата ТТН</th>
    <th rowspan="2">Номер ТТН</th>
    <th rowspan="2">Наименование организации грузополучателя</th>
    <th rowspan="2">ИНН</th>
    <th rowspan="2">КПП</th>
    <th rowspan="2">масса груза (брутто), (т)/(дал)</th>
    </tr>
    <tr>
    <th>наименование</th>
    <th>ИНН</th>
    <th>КПП</th>
    <th>ф.и.о.</th>
    <th>адрес места жительства</th>
    <th>серия, номер</th>
    <th>дата выдачи</th>
    <th>дата окончания дейстствия</th>
    <th>кем выдана</th>
    </tr>
    <xsl:apply-templates select="Документ/ОбъемПеревозки"/>
    </table>
</xsl:template>

<xsl:template match="ОбъемПеревозки">
    <tr class="div">
    <td></td>
    <th colspan="7">По подразделению:</th>
    <td colspan="17">
        <xsl:value-of select="@НаимЮЛ"/>,
        КПП: <xsl:value-of select="@КППЮЛ"/>.
        <xsl:apply-templates select="АдрОрг"/>
    </td>
    </tr>
    <xsl:apply-templates select="Перевозка"/>
    <tr class="sum">
    <td></td>
    <td colspan="16">Итого:</td>
    <td class="num"><xsl:value-of select="round(sum(Перевозка/Продукция/СведПеревозчик/ТранспортноеСредство/СведТН/@П000000000016)*100000) div 100000"/></td>
    <td colspan="5"></td>
    <td class="num"><xsl:value-of select="round(sum(Перевозка/Продукция/СведПеревозчик/ТранспортноеСредство/СведТН/СведТТН/@П000000000019)*100000) div 100000"/></td>
    <td class="num"><xsl:value-of select="round(sum(Перевозка/Продукция/СведПеревозчик/ТранспортноеСредство/СведТН/СведТТН/@П000000000020)*100000) div 100000"/></td>
    </tr>
</xsl:template>

<xsl:template match="СведТТН">
    <tr>
    <td><xsl:number level="any" from="ОбъемПеревозки" count="СведТТН"/></td>
    <td><xsl:value-of select="../../../../../@П000000000002"/></td>
    <td><xsl:value-of select="../../../../@П000000000004"/></td>
    <xsl:apply-templates select="../../../@ИдПеревозчика"/>
    <xsl:choose>
        <xsl:when test="../../../@ИдЛицензии"><xsl:apply-templates select="../../../@ИдЛицензии"/></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="document('')//lookup:empty/Лицензия"/></xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="../../@ИдТС"/>
    <td><xsl:value-of select="../@П000000000014"/></td>
    <td><xsl:value-of select="../@П000000000015"/></td>
    <td class="num"><xsl:value-of select="../@П000000000016"/></td>
    <td><xsl:value-of select="@П000000000017"/></td>
    <td><xsl:value-of select="@П000000000018"/></td>
    <xsl:apply-templates select="@ИдПолучателя"/>
    <td class="num"><xsl:value-of select="@П000000000019"/></td>
    <td class="num"><xsl:value-of select="@П000000000020"/></td>
    </tr>
</xsl:template>
<!-- ======================================================================= -->

<xsl:template match="@П000000000003">
    <td>
        <xsl:call-template name="Lookup">
            <xsl:with-param name="table">Product</xsl:with-param>
            <xsl:with-param name="key" select="."/>
        </xsl:call-template>
    </td>
    <td class="code"><xsl:value-of select="."/></td>
</xsl:template>

<xsl:template match="@ИдПроизвИмп">
    <xsl:apply-templates select="key('Manufacturer', .)"/>
</xsl:template>

<xsl:template match="ПроизводителиИмпортеры">
    <td><xsl:value-of select="@П000000000004"/></td>
    <td><xsl:value-of select="@П000000000005"/></td>
    <td><xsl:value-of select="@П000000000006"/></td>
</xsl:template>

<xsl:template match="@ИдПолучателя">
    <xsl:variable name="c"><xsl:choose>
        <xsl:when test="local-name(..)='СведТТН'">Recipient</xsl:when>
        <xsl:otherwise>Customer</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:apply-templates select="key($c, .)"/>
</xsl:template>

<xsl:template match="@ИдПоставщика">
    <xsl:apply-templates select="key('Supplier', .)"/>
</xsl:template>

<xsl:template match="Контрагенты|Поставщики">
    <td><xsl:value-of select="@П000000000007"/></td>
    <td><xsl:apply-templates select="Резидент/П000000000008"/></td>
    <td><xsl:value-of select="Резидент/*/@П000000000009"/></td>
    <td><xsl:value-of select="Резидент/ЮЛ/@П000000000010"/></td>
</xsl:template>

<xsl:template match="Получатели">
    <td><xsl:value-of select="@П000000000019"/></td>
    <xsl:choose>
        <xsl:when test="ОрганизацияРФ">
            <td><xsl:value-of select="ОрганизацияРФ/@П000000000020"/></td>
            <td><xsl:value-of select="ОрганизацияРФ/@П000000000021"/></td>
        </xsl:when>
        <xsl:otherwise>
            <td></td>
            <td></td>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="@ИдПеревозчика">
    <xsl:apply-templates select="key('Carrier', .)"/>
</xsl:template>

<xsl:template match="Перевозчики">
    <xsl:choose>
        <xsl:when test="ПеревозчикЮрЛицо">
            <td><xsl:value-of select="ПеревозчикЮрЛицо/@П000000000003"/></td>
            <td><xsl:value-of select="ПеревозчикЮрЛицо/@П000000000004"/></td>
            <td><xsl:value-of select="ПеревозчикЮрЛицо/@П000000000005"/></td>
            <td></td>
            <td></td>
        </xsl:when>
        <xsl:otherwise>
            <td></td>
            <td></td>
            <td></td>
            <td><xsl:apply-templates select="ПеревозчикФизЛицо/ФИО"/></td>
            <td><xsl:apply-templates select="ПеревозчикФизЛицо/Адрес"/></td>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="@ИдЛицензии">
    <xsl:variable name="key"><xsl:choose>
        <xsl:when test="local-name(..)='СведПеревозчик'">LicenseCarrier</xsl:when>
        <xsl:otherwise>License</xsl:otherwise>
    </xsl:choose></xsl:variable>
    <xsl:apply-templates select="key($key, .)"/>
</xsl:template>

<xsl:template name="Лицензия" match="Лицензия">
    <xsl:choose>
        <xsl:when test="local-name(../..)='Перевозчики'">
            <td><xsl:value-of select="@П000000000008"/></td>
            <td><xsl:value-of select="@П000000000009"/></td>
            <td><xsl:value-of select="@П000000000010"/></td>
            <td><xsl:value-of select="@П000000000011"/></td>
        </xsl:when>
        <xsl:otherwise>
            <td><xsl:value-of select="@П000000000011"/></td>
            <td><xsl:value-of select="@П000000000012"/></td>
            <td><xsl:value-of select="@П000000000013"/></td>
            <td><xsl:value-of select="@П000000000014"/></td>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="@ИдТС">
    <xsl:apply-templates select="key('Vehicle', .)"/>
</xsl:template>

<xsl:template match="КодСтраны">
    <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="ТранспортныеСредства">
    <td><xsl:value-of select="@П000000000012"/></td>
    <td><xsl:value-of select="@П000000000013"/></td>
    <td><xsl:value-of select="@П000000000014"/></td>
</xsl:template>

<xsl:template match="Индекс|КодРегион|Район|Город|НаселПункт|Улица"
    >, <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="Дом"
    >, д. <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="Корпус"
    >, корп. <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="Литера"
    >, лит. <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="Кварт"
    >, кв. <xsl:value-of select="."/>
</xsl:template>


<xsl:key name="Manufacturer" match="Файл/Справочники/ПроизводителиИмпортеры" use="@ИдПроизвИмп"/>
<xsl:key name="Customer" match="Файл/Справочники/Контрагенты" use="@ИдКонтр"/>
<xsl:key name="Supplier" match="Файл/Справочники/Поставщики" use="@ИдПостав"/>
<xsl:key name="License" match="Файл/Справочники/*/Резидент/Лицензии/Лицензия" use="@ИдЛицензии"/>
<xsl:key name="Recipient" match="Файл/Справочники/Получатели" use="@ИдПолучателя"/>
<xsl:key name="Carrier" match="Файл/Справочники/Перевозчики" use="@ИдПеревозчика"/>
<xsl:key name="LicenseCarrier" match="Файл/Справочники/Перевозчики/Лицензии/Лицензия" use="@ИдЛицензии"/>
<xsl:key name="Vehicle" match="Файл/Справочники/ТранспортныеСредства" use="@ИдТС"/>

<xsl:template name="Lookup">
    <xsl:param name="table"/>
    <xsl:param name="key"/>
    <xsl:for-each select="document('')">
        <xsl:value-of select="key($table, $key)"/>
    </xsl:for-each>
</xsl:template>

<xsl:key name="BisnessType4.20" match="lookup:bisnessTypes/lookup:bisnessType" use="@code"/>

<lookup:bisnessTypes>
    <lookup:bisnessType code="07">Закупка, хранение и поставки алкогольной продукции</lookup:bisnessType>
    <lookup:bisnessType code="08">Закупка, хранение и поставки спиртосодержащей пищевой продукции</lookup:bisnessType>
    <lookup:bisnessType code="09">Закупка, хранение и поставки спиртосодержащей непищевой продукции</lookup:bisnessType>
    <lookup:bisnessType code="10">Хранение алкогольной продукции</lookup:bisnessType>
    <lookup:bisnessType code="11">Хранение спиртосодержащей пищевой продукции</lookup:bisnessType>
    <lookup:bisnessType code="12">Хранение этилового спирта</lookup:bisnessType>
    <lookup:bisnessType code="16">Организация, осуществляющая производство и оборот пива и пивных напитков</lookup:bisnessType>
</lookup:bisnessTypes>

<xsl:key name="BisnessType4.30" match="lookup:bisnessTypes/lookup:bisnessType" use="@code"/>

<lookup:bisnessTypes>
    <lookup:bisnessType code="01">Производство, хранение и поставки произведенного этилового спирта, в том числе денатурата</lookup:bisnessType>
    <lookup:bisnessType code="02">Производство, хранение и поставки произведенной алкогольной и спиртосодержащей пищевой продукции</lookup:bisnessType>
    <lookup:bisnessType code="03">Закупка, хранение и поставки алкогольной и спиртосодержащей продукции</lookup:bisnessType>
    <lookup:bisnessType code="04"> Производство, хранение и поставки спиртосодержащей непищевой продукции</lookup:bisnessType>
    <lookup:bisnessType code="05">Хранение этилового спирта, алкогольной и спиртосодержащей пищевой продукции</lookup:bisnessType>
</lookup:bisnessTypes>

<xsl:key name="Title" match="lookup:titles/lookup:title" use="@code"/>

<lookup:titles>
    <lookup:title code="01" >Декларация об объемах производства и оборота этилового спирта</lookup:title>
    <lookup:title code="02" >Декларация об объемах использования этилового спирта</lookup:title>
    <lookup:title code="03" >Декларация об объемах производства и оборота алкогольной и спиртосодержащей продукции</lookup:title>
    <lookup:title code="04" >Декларация об объемах использования алкогольной и спиртосодержащей продукции</lookup:title>
    <lookup:title code="05" >Декларация об объеме оборота этилового спирта, алкогольной и спиртосодержащей продукции</lookup:title>
    <lookup:title code="06" >Декларация об объемах поставки этилового спирта, алкогольной и спиртосодержащей продукции</lookup:title>
    <lookup:title code="07" >Декларация об объемах закупки этилового спирта, алкогольной и спиртосодержащей продукции</lookup:title>
    <lookup:title code="08" >Декларация о перевозках этилового спирта, алкогольной и спиртосодержащей продукции</lookup:title>
    <lookup:title code="09" >Декларация о перевозках этилового спирта (в том числе денатурированного) и нефасованной спиртосодержащей продукции с содержанием этилового спирта более 25 процентов объема готовой продукции</lookup:title>
    <lookup:title code="10">Декларация об использовании  мощностей по производству этилового спирта и алкогольной продукции</lookup:title>
    <lookup:title code="11">Декларация об объемах розничной продажи алкогольной и спиртосодержащей продукции</lookup:title>
    <lookup:title code="12">Декларация об объемах розничной продажи  пива и пивных напитков</lookup:title>
</lookup:titles>

<xsl:key name="Product" match="lookup:products/lookup:product" use="@code"/>

<lookup:products>
    <lookup:product code="010">Спирт-сырец этиловый из пищевого сырья</lookup:product>
    <lookup:product code="020">Спирт этиловый ректификованный из пищевого сырья</lookup:product>
    <lookup:product code="025">Спирт этиловый ректификованный из непищевого растительного сырья</lookup:product>
    <lookup:product code="030">Спирт этиловый из ЭАФ</lookup:product>
    <lookup:product code="040">Спирт этиловый синтетический</lookup:product>
    <lookup:product code="050">Спирт этиловый абсолютированный</lookup:product>
    <lookup:product code="060">Другие спирты (за исключением денатурированных)</lookup:product>
    <lookup:product code="070">Спирт этиловый денатурированный из пищевого сырья</lookup:product>
    <lookup:product code="080">Спирт этиловый денатурированный из непищевого сырья</lookup:product>
    <lookup:product code="090">Фракция головная этилового спирта</lookup:product>
    <lookup:product code="091">Фракция головных и промежуточных примесей этилового спирта</lookup:product>
    <lookup:product code="092">Промежуточная фракция этилового спирта из пищевого сырья</lookup:product>
    <lookup:product code="100">Спирт этиловый по фармакопейным статьям</lookup:product>
    <lookup:product code="110">Коньячный дистиллят</lookup:product>
    <lookup:product code="120">Кальвадосный дистиллят</lookup:product>
    <lookup:product code="130">Винный дистиллят</lookup:product>
    <lookup:product code="140">Спирт этиловый питьевой</lookup:product>
    <lookup:product code="150">Виноградный дистиллят</lookup:product>
    <lookup:product code="160">Плодовый дистиллят</lookup:product>
    <lookup:product code="170">Висковый дистиллят</lookup:product>
    <lookup:product code="200">Водка</lookup:product>
    <lookup:product code="211">Ликероводочные изделия с содержанием этилового спирта до 25% включительно</lookup:product>
    <lookup:product code="212">Ликероводочные изделия с содержанием этилового спирта свыше 25%</lookup:product>
    <lookup:product code="229">Коньяк и арманьяк, реализуемые в бутылках</lookup:product>
    <lookup:product code="230">Коньяки,реализуемые в бутылках</lookup:product>
    <lookup:product code="231">Коньяки обработанные, предназначенные для отгрузки с целью розлива на других предприятиях или промпереработки</lookup:product>
    <lookup:product code="232">Бренди</lookup:product>
    <lookup:product code="238">Напитки коньячные с содержанием этилового спирта до 25% включительно</lookup:product>
    <lookup:product code="239">Напитки коньячные с содержанием этилового спирта свыше 25%</lookup:product>
    <lookup:product code="241">Напитки коньячные, бренди с содержанием этилового спирта до 25% включительно</lookup:product>
    <lookup:product code="242">Напитки коньячные, бренди с содержанием этилового спирта свыше 25%</lookup:product>
    <lookup:product code="250">Напитки винные с содержанием этилового спирта до 25% включительно</lookup:product>
    <lookup:product code="251">Напитки винные с содержанием этилового спирта свыше 25%</lookup:product>
    <lookup:product code="252">Кальвадос</lookup:product>
    <lookup:product code="260">Слабоалкогольная продукция</lookup:product>
    <lookup:product code="261">Сидр</lookup:product>
    <lookup:product code="262">Пуаре</lookup:product>
    <lookup:product code="263">Медовуха</lookup:product>
    <lookup:product code="270">Другие спиртные напитки с содержанием этилового спирта до 25% включительно</lookup:product>
    <lookup:product code="280">Другие спиртные напитки с содержанием этилового спирта свыше 25%</lookup:product>
    <lookup:product code="300">Коньячные спирты</lookup:product>
    <lookup:product code="310">Кальвадосные спирты</lookup:product>
    <lookup:product code="320">Виноматериалы</lookup:product>
    <lookup:product code="321">Виноматериалы виноградные</lookup:product>
    <lookup:product code="322">Виноматериалы плодовые</lookup:product>
    <lookup:product code="330">Соки спиртованные</lookup:product>
    <lookup:product code="331">Соки сброженно-спиртованные</lookup:product>
    <lookup:product code="340">Дистилляты</lookup:product>
    <lookup:product code="341">Фруктовое сусло</lookup:product>
    <lookup:product code="342">Медовое сусло</lookup:product>
    <lookup:product code="343">Пивное сусло</lookup:product>
    <lookup:product code="344">Виноградное сусло</lookup:product>
    <lookup:product code="350">Другая спиртосодержащая пищевая продукция</lookup:product>
    <lookup:product code="351">Другая спиртосодержащая пищевая продукция</lookup:product>
    <lookup:product code="400">Вина натуральные</lookup:product>
    <lookup:product code="401">Вино (виноградное)</lookup:product>
    <lookup:product code="402">Вино с защищенным географическим указанием или с защищенным наименованием места происхождения</lookup:product>
    <lookup:product code="403">Вино (виноградное столовое)</lookup:product>
    <lookup:product code="410">Вина (за исключением натуральных, игристых и шампанских)</lookup:product>
    <lookup:product code="411">Ликерное вино</lookup:product>
    <lookup:product code="420">Вина плодовые</lookup:product>
    <lookup:product code="421">Фруктовое (плодовое) вино</lookup:product>
    <lookup:product code="440">Вина игристые</lookup:product>
    <lookup:product code="450">Вина шампанские</lookup:product>
    <lookup:product code="460">Другие вина</lookup:product>
    <lookup:product code="461">Винный напиток с объемной долей этилового спирта от 1,5% до 22%, произведенный без добавления этилового спирта</lookup:product>
    <lookup:product code="462">Винный напиток с объемной долей этилового спирта от 1,5% до 22%, произведенный с добавлением этилового спирта</lookup:product>
    <lookup:product code="481">Парфюмерно-косметическая продукция</lookup:product>
    <lookup:product code="482">Товары бытовой химии</lookup:product>
    <lookup:product code="483">Спиртосодержащие растворы</lookup:product>
    <lookup:product code="484">Другая спиртосодержащая непищевая продукция</lookup:product>
    <lookup:product code="485">Денатурированная спиртосодержащая непищевая продукция</lookup:product>
    <lookup:product code="500">Пиво с содержанием объемной доли этилового спирта свыше 0,5% и до 8,6% включительно</lookup:product>
    <lookup:product code="510">Пиво с содержанием объемной доли этилового спирта свыше 8,6%</lookup:product>
    <lookup:product code="520">Напитки, изготавливаемые на основе пива</lookup:product>
</lookup:products>

<lookup:empty>
    <Лицензия/>
</lookup:empty>

<xsl:template name="CSS">
    <style>html {}
    </style>
</xsl:template>

</xsl:stylesheet>


