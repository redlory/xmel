// ==UserScript==
// @name        Хмель
// @namespace   https://github.com/redlory
// @description Декларация по этиловому спирту
// @downloadURL https://github.com/redlory/xmel/raw/master/xmel.user.js
// @updateURL   https://github.com/redlory/xmel/raw/master/xmel.meta.js
// @include     file://*.xml
// @version     1.1.0
// @resource    xsl xmel.xsl
// @resource    css xmel.css
// @grant       GM_getResourceText
// ==/UserScript==

function applyXSL () {
    var parser = new DOMParser();
    var xsl = parser.parseFromString (GM_getResourceText ("xsl"),
        "application/xml");
    
    // Добавить стили css в правила транформации xsl.
    // Добавление их после транформации в html не работает.
    var s = xsl.getElementsByTagName ("style");
    s[0].firstChild.nodeValue = GM_getResourceText ("css");
    
    var processor = new XSLTProcessor();
    processor.importStylesheet (xsl);

    // Далее - выкрутас из-за не правильно работающего document('').
    // Встроить xsl в обрабатываемый им xml,
    // чтобы через select-of="document('')" получить к нему доступ.
    // Почему-то document('') возращает _обрабатываемый_ документ,
    // а не правила трансформации xsl, как должно быть.
    document.documentElement.appendChild (document.importNode (
        xsl.getElementsByTagNameNS ("https://github.com/redlory/xmel/lookup", "refs").item (0),
        true));
    
    //трансформировать в html и отобразить
    var newDoc = processor.transformToDocument(document);
    document.replaceChild (document.adoptNode (newDoc.documentElement),
        document.documentElement);
}

if (document.documentElement.nodeName == "Файл") {
    var form = "";
    var version = document.documentElement.attributes["ВерсФорм"].value;
    var n = document.getElementsByTagName ("ФормаОтч");
    if (n.length == 1) form = n[0].attributes["НомФорм"].value;
    if ((version == "4.20"
            && (   form == "5-о"
                || form == "6-о"
                || form == "7-о"
                || form == "8-о"
                ))
        || ((version == "4.30" || version == "4.31")
            && (   form == "05"
                || form == "06"
                || form == "07"
                || form == "08"
                ))
        )
    {
        applyXSL ();
    }
}

