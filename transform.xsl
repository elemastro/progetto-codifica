<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml">
    <xsl:output method="html" encoding="UTF-8" />

    <!--struttura dell'html-->
    <xsl:template match="/">
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <link rel="stylesheet" type="text/css" href="style.css" />
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script><!--jquery-->
                <script type="text/javascript" src="codifica.js"></script>
                <title>Codifica Rassegna Settimanale</title>
            </head>
            <body>
                <header>
                    <a href="https://rassegnasettimanale.animi.it/"><img src="rassegna_sett.png" alt="logo del sito della Rassegna Settimanale"/></a>
                </header>
                <div id="titolo_c">
                    <h1>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                    </h1>
                    <h2>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:resp"/>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName[@xml:id='em']"/> e
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName[@xml:id='dp']"/>
                    </h2>
                </div>
                <div id="menu_art">
                    <button>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:biblStruct/tei:analytic[@xml:id='art1']/tei:title"/>
                    </button>
                    <button>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:biblStruct/tei:analytic[@xml:id='art2']/tei:title"/>
                    </button>
                    <button>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:biblStruct/tei:analytic[@xml:id='art3']/tei:title"/>
                    </button>
                    <button>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:biblStruct/tei:analytic[@xml:id='bibl1']/tei:title"/>
                    </button>
                    <button>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:biblStruct/tei:analytic[@xml:id='bibl2']/tei:title"/>
                    </button>
                    <button>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:biblStruct/tei:analytic[@xml:id='notizie']/tei:title"/>
                    </button>
                </div>

                <!--testi e facsimile-->
                <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div[@type='journal']/tei:div">
                    <div class="contenitore">
                        <div class="titolo_a">
                            <h3>
                                <xsl:value-of select="tei:head"/>
                            </h3>
                        </div>
                        <xsl:for-each select="tei:pb">
                            <xsl:variable name="pb_id">
                                <xsl:value-of select="@xml:id"/>
                            </xsl:variable>
                            <div class="testo_codificato">
                                <table class="cont_testo">
                                    <tr>
                                        <th>Colonna 1</th>
                                        <th>Colonna 2</th>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="colonna_sx">
                                                <xsl:apply-templates select="following-sibling::tei:cb[@corresp=concat('#', $pb_id) and @n=1]/tei:p" />
                                            </div>
                                        </td>
                                        <td>
                                            <div class="colonna_dx">
                                                <xsl:apply-templates select="following-sibling::tei:cb[@corresp=concat('#', $pb_id) and @n=2]/tei:p" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </xsl:for-each>
                        <!--<div class="facsimile">
                            <xsl:apply-templates select="."/>si mette il punto perché questo identifica il nodo su cui stiamo lavorando e il processore cerca il suo template corrispondente
                        </div>-->
                    </div>
                </xsl:for-each>


                <footer>
                    <p>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:encodingDesc/tei:projectDesc/tei:p"/>
                    </p>
                </footer>

            </body>
        </html>
    </xsl:template>


    <!--pb-->
    <xsl:template match="tei:pb">
        <xsl:variable name="id_pb" select="substring-after(@facs, '#')" /><!--come id prende il codice che si trova dopo # dell'attributo facs-->
        <xsl:apply-templates select="//tei:facsimile/tei:surface[@xml:id=$id_pb]" />
    </xsl:template>

    <!--cb-->
    <xsl:template match="tei:cb">
        <xsl:variable name="id_cb" select="@xml:id"/>
        <xsl:element name="span">
            <xsl:attribute name="id">
                <xsl:value-of select="$id_cb"/>
            </xsl:attribute>
        </xsl:element>
        <xsl:apply-templates select="following-sibling::tei:*[@corresp=concat('#', $id_cb)]"/>
        <xsl:apply-templates select="following-sibling::tei:div/tei:*[@corresp=concat('#', $id_cb)]"/>
    </xsl:template>

    <!--head-->
    <xsl:template match="tei:head">
        <div class="titolo_a">
            <xsl:element name="span">
                <xsl:attribute name="id">
                    <xsl:value-of select="substring-after(@facs, '#')"/>
                </xsl:attribute>
            </xsl:element>
            <strong><xsl:value-of select="@xml:id"/></strong>
            <div class="testo">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>

    <!--p-->
    <xsl:template match="tei:p">
        <div class="testo_codificato">
            <xsl:element name="span">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <strong><xsl:value-of select="@xml:id"/></strong>
            </xsl:element>
            <div class="testo">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>

    <!--surface-->
    <xsl:template match="tei:surface">
        <xsl:element name="img"><!--diventano tag img con una mappa immagine associata-->
            <xsl:attribute name="src"><xsl:value-of select="tei:graphic/@url"/></xsl:attribute><!--mette l'attributo src al tag img con valore l'url preso dall'elemento tei:graphic-->
            <xsl:attribute name="class">facsimile</xsl:attribute>
            <xsl:attribute name="usemap">#<xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of select="@xml:id"/></xsl:attribute>
        </xsl:element>
        <xsl:element name="map">
            <xsl:attribute name="name"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <xsl:for-each select="tei:zone">
                <xsl:element name="area">
                    <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
                    <xsl:attribute name="coords"><xsl:value-of select="@ulx"/>,<xsl:value-of select="@uly"/>,<xsl:value-of select="@lrx"/>,<xsl:value-of select="@lry"/></xsl:attribute>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>