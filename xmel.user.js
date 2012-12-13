// ==UserScript==
// @name        Хмель
// @namespace   http://github.com/redlory/xmel
// @description Декларация по этиловому спирту
// @include     file://*.xml
// @version     1.0.0
// @resource    xsl xmel.xsl
// @resource    css xmel.css
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
    document.documentElement.appendChild (document.adoptNode (
        xsl.documentElement));
    
    //трансформировать в html и отобразить
    var newDoc = processor.transformToDocument(document);
    document.replaceChild (document.adoptNode (newDoc.documentElement),
        document.documentElement);
}

if (document.documentElement.nodeName == "Файл") {
    var version = document.documentElement.attributes["ВерсФорм"].value;
    var n = document.getElementsByTagName ("ФормаОтч");
    if (n.length != 1) return;
    var form = n[0].attributes["НомФорм"].value;
    if (version == "4.20"
            && (   form == "5-о"
                || form == "6-о"
                || form == "7-о"
                || form == "8-о"
                ))
    {
        applyXSL ();
    }
}

