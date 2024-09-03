<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml">
    
    <xsl:output method="html" encoding="UTF-8" />

    <!-- Struttura dell'HTML -->
    <xsl:template match="/">
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                <link href='https://fonts.googleapis.com/css?family=Libre Baskerville' rel='stylesheet' />
                <link rel="stylesheet" type="text/css" href="stile.css" />
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script> <!-- jQuery -->
                <script type="text/javascript" src="codifica.js"></script>
                <title>Codifica Rassegna Settimanale</title>
            </head>
            <body>
                <header>
                    <a href="https://rassegnasettimanale.animi.it/">
                        <img src="rassegna_sett.png" alt="logo del sito della Rassegna Settimanale" />
                    </a>
                    <button class="but_informazioni">INFORMAZIONI</button>
                </header>
                <div id="titolo_c">
                    <h1>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
                    </h1>
                    <h2>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:resp"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName[@xml:id='em']"/> e
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName[@xml:id='dp']"/>
                    </h2>
                </div>

                <div class="informazioni">
                    <div class="inf_codifica">
                        <xsl:apply-templates select="tei:TEI/tei:teiHeader/tei:encodingDesc"/>
                    </div>
                </div>

                <div class="informazioni">
                    <div class="inf_bibliografiche">
                        <xsl:apply-templates select="tei:TEI/tei:teiHeader/tei:fileDesc"/>
                    </div>
                </div>

                <div id="menu_art">
                    <xsl:for-each select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listBibl/tei:biblStruct/tei:analytic">
                        <button>
                            <xsl:value-of select="tei:title"/>
                        </button>
                    </xsl:for-each>
                </div>

                <!-- Testi e facsimile -->
                <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div[@type='journal']/tei:div">
                    <div class="contenitore">
                        <div class="titolo_a">
                            <h3>
                                <xsl:value-of select="tei:head"/>
                            </h3>
                        </div>
                        <xsl:for-each select="tei:pb">
                            <xsl:variable name="pb_id" select="@xml:id"/>
                            <div class="testo_codificato">
                                <table class="cont_testo">
                                    <tr>
                                        <th>Colonna 1</th>
                                        <th>Colonna 2</th>
                                    </tr>
                                    <tr>
                                        <td class="colonne_testo">
                                            <div class="colonna_sx">
                                                <xsl:apply-templates select="
                                                    following-sibling::tei:cb[@corresp=concat('#', $pb_id) and @n=1]/following-sibling::*[
                                                        self::tei:head or self::tei:p or self::tei:ab or self::tei:list or self::tei:item or self::tei:closer or self::tei:note
                                                    ][preceding-sibling::tei:cb[1][@corresp=concat('#', $pb_id) and @n=1] 
                                                    and preceding-sibling::tei:pb[1][@xml:id=$pb_id]]"/>
                                            </div>
                                        </td>
                                        <td class="colonne_testo">
                                            <div class="colonna_dx">
                                                <xsl:apply-templates select="
                                                    following-sibling::tei:cb[@corresp=concat('#', $pb_id) and @n=2]/following-sibling::*[
                                                        self::tei:head or self::tei:p or self::tei:ab or self::tei:list or self::tei:item or self::tei:closer or self::tei:note
                                                    ][preceding-sibling::tei:cb[1][@corresp=concat('#', $pb_id) and @n=2] 
                                                    and preceding-sibling::tei:pb[1][@xml:id=$pb_id]]"/>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <div class="facsimile">
                                    <xsl:apply-templates select="."/>
                                </div>
                            </div>
                        </xsl:for-each>
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

    <!-- Template per pb -->
    <xsl:template match="tei:pb">
        <xsl:variable name="id_pb" select="substring-after(@facs, '#')"/>
        <xsl:apply-templates select="//tei:facsimile/tei:surface[@xml:id=$id_pb]" />
    </xsl:template>

    <!-- Template per cb -->
    <xsl:template match="tei:cb">
        <xsl:variable name="id_cb" select="@xml:id"/>
        <span id="{$id_cb}"></span>
        <xsl:apply-templates select="following-sibling::tei:*[@corresp=concat('#', $id_cb)]"/>
        <xsl:apply-templates select="following-sibling::tei:div/tei:*[@corresp=concat('#', $id_cb)]"/>
    </xsl:template>

    <!-- Template per lb -->
    <xsl:template match="tei:lb">
        <div class="riga"></div>
    </xsl:template>

    <!-- Template per head -->
    <xsl:template match="tei:head">
        <div class="titolo_a">
            <span id="{substring-after(@facs, '#')}"></span>
            <xsl:value-of select="@xml:id"/>
            <div class="titolo">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>

    <!-- Template per ab -->
    <xsl:template match="tei:ab">
        <div class="testo_codificato">
            <div id="{@xml:id}">
                <xsl:value-of select="@xml:id"/>
            </div>
        </div>
        <div class="iscr_bibl">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Template per p -->
    <xsl:template match="tei:p">
        <div class="testo_codificato">
            <div id="{@xml:id}">
                <xsl:value-of select="@xml:id"/>
            </div>
            <div class="testo">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>

    <!-- Template per list -->
    <xsl:template match="tei:list">
        <div class="testo_codificato">
            <div class="testo">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>

    <!-- Template per item -->
    <xsl:template match="tei:item">
        <div class="testo_codificato">
            <span id="{@xml:id}">
                <xsl:value-of select="@xml:id"/>
            </span>
            <div class="testo">
                <xsl:apply-templates />
            </div>
        </div>
    </xsl:template>

    <!-- Template per closer -->
    <xsl:template match="tei:closer">
        <div class="testo_codificato">
            <span id="{@xml:id}">
                <xsl:value-of select="@xml:id"/>
            </span>
            <div class="testo">
                <xsl:apply-templates/>
            </div>
        </div>
    </xsl:template>

    <!-- Template per surface -->
    <xsl:template match="tei:surface">
        <img src="{tei:graphic/@url}" class="facsimile" usemap="#{@xml:id}" alt="{@xml:id}"/>
        <map name="{@xml:id}">
            <xsl:for-each select="tei:zone">
                <area id="{@xml:id}" coords="{@ulx},{@uly},{@lrx},{@lry}" />
            </xsl:for-each>
        </map>
    </xsl:template>

    <!--Template per encodingDesc-->
    <xsl:template match="tei:encodingDesc">
        <h3>Informazioni sul progetto e sulla codifica</h3>
        <dl>
            <dt>Finalità del progetto</dt>
            <dd>
                <xsl:value-of select="tei:projectDesc/tei:p"/>
            </dd>
            <dt>Selezione dei testi</dt>
            <dd>
                <xsl:value-of select="tei:samplingDecl/tei:p"/>
            </dd>
            <dt>Strumenti usati per la realizzazione</dt>
                <xsl:for-each select="tei:appInfo/tei:application">
                    <dd>
                        <strong><xsl:value-of select="tei:label"/>:</strong>
                        <xsl:value-of select="concat(' Versione ', @version, ', Identificativo: ', @ident)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="tei:p"/>
                    </dd>
                </xsl:for-each>
            <dt>Correzioni</dt>
            <dd>
                <xsl:value-of select="tei:editorialDecl/tei:correction/tei:p"/>
            </dd>
            <dt>Unione con trattino</dt>
            <dd>
                <xsl:value-of select="tei:editorialDecl/tei:hyphenation/tei:p"/>
            </dd>
            <dt>Normalizzazioni</dt>
            <dd>
                <xsl:value-of select="tei:editorialDecl/tei:normalization/tei:p"/>
            </dd>
            <dt>Punteggiatura</dt>
            <dd>
                <xsl:value-of select="tei:editorialDecl/tei:punctuation/tei:p"/>
            </dd>
            <dt>Citazioni</dt>
            <dd>
                <xsl:value-of select="tei:editorialDecl/tei:quotation/tei:p"/>
            </dd>
        </dl>
    </xsl:template>

    <!--Template per fileDesc-->
    <xsl:template match="tei:fileDesc">
        <h3>Informazioni bibliografiche</h3>
        <table>
            <tr>
                <th class="tab_principale">Edizione virtuale</th>
                <td>
                    <xsl:apply-templates select="tei:editionStmt"/>
                </td>
            </tr>
            <tr>
                <th></th>
                <td>
                    <xsl:apply-templates select="tei:publicationStmt"/>
                </td>
            </tr>
            <tr>
                <th class="tab_principale">Note</th>
                <td>
                    <xsl:for-each select="tei:notesStmt/tei:note">
                        <xsl:value-of select="."/>
                        <br/>       
                    </xsl:for-each>
                </td>
            </tr>
            <tr>
                <th class="tab_principale">Fonte</th>
                <td>
                    <xsl:apply-templates select="tei:sourceDesc"/>
                </td>
            </tr>
            <tr>
                <th class="tab_principale">Parti codificate</th>
                <td>
                    <xsl:apply-templates select="tei:sourceDesc/tei:listBibl/tei:biblStruct"/>
                </td>
            </tr>
            <tr>
                <th>Pagine per ogni volume</th>
                <td>
                    <table>
                        <xsl:for-each select="tei:sourceDesc/tei:listBibl/tei:biblStruct/tei:monogr/tei:biblScope[@unit='volume']">
                            <tr>
                                <th class="td_pag">
                                    Volume <xsl:value-of select="."/>
                                </th>
                                <td class="td_pag">
                                    <xsl:value-of select="../tei:biblScope[@unit='page' and @corresp=current()/@xml:id]"/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template>

    <!--Template per biblStruct (partendo da sourceDesc)-->
    <xsl:template match="tei:sourceDesc/tei:listBibl/tei:biblStruct">
        <table>
            <xsl:for-each select="tei:analytic">
                <tr>
                    <th>
                        <xsl:value-of select="tei:title"/>
                    </th>
                    <td>
                        <table class="tab_art">
                            <tr>
                                <th>Volume</th>
                                <td>
                                    <xsl:value-of select="../tei:monogr/tei:biblScope[@unit='volume' and @xml:id=current()/@corresp]"/>
                                </td>
                            </tr>
                            <tr>
                                <th>Fascicolo</th>
                                <td>
                                    <xsl:value-of select="../tei:monogr/tei:biblScope[@unit='issue' and @corresp=current()/@corresp]"/>
                                </td>
                            </tr>
                            <tr>
                                <th>Data di pubblicazione</th>
                                <td>
                                    <xsl:value-of select="../tei:monogr/tei:imprint/tei:date[@corresp=current()/@corresp]"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>

    <!--Template per sourceDesc-->
    <xsl:template match="tei:sourceDesc">
        <table>
            <tr>
                <th>Titolo</th>
                <td>
                    <xsl:value-of select="tei:listBibl/tei:biblStruct/tei:monogr/tei:title"/>
                </td>
            </tr>
            <tr>
                <th>Fondatori</th>
                <td>
                    <xsl:apply-templates select="tei:listBibl/tei:biblStruct/tei:monogr/tei:respStmt"/>
                </td>
            </tr>
            <tr>
                <th>Lingua</th>
                <td>
                    <xsl:value-of select="tei:listBibl/tei:biblStruct/tei:monogr/tei:textLang"/>
                </td>
            </tr>
            <tr>
                <th>Editore</th>
                <td>
                    <xsl:value-of select="tei:listBibl/tei:biblStruct/tei:monogr/tei:imprint/tei:publisher"/>
                </td>
            </tr>
            <tr>
                <th>Luogo</th>
                <td>
                    <xsl:value-of select="tei:listBibl/tei:biblStruct/tei:monogr/tei:imprint/tei:pubPlace"/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <!--Template per editionStmt-->
    <xsl:template match="tei:editionStmt">
        <table>
            <tr>
                <td>
                    <xsl:value-of select="tei:edition"/>
                    <xsl:apply-templates select="tei:respStmt"/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <!--Template per respStmt-->
    <xsl:template match="tei:respStmt">
        <xsl:for-each select="*">
            <xsl:value-of select="." />
            <!-- Inserisce "e" prima dell'ultimo elemento -->
            <xsl:if test="position() = last() - 1">
                <xsl:text> e </xsl:text>
            </xsl:if>
            <!-- Inserisce uno spazio dopo ogni elemento tranne l'ultimo -->
            <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--Template per publicationStmt-->
    <xsl:template match="tei:publicationStmt">
        <table>
            <tr>
                <th>Editore</th>
                <td>
                    <xsl:value-of select="tei:publisher"/>
                </td>
            </tr>
            <tr>
                <th>Indirizzo</th>
                <td>
                    <xsl:apply-templates select="tei:address"/>
                </td>
            </tr>
            <tr>
                <th>Disponibilità</th>
                <td>
                    <xsl:value-of select="tei:availability/tei:p"/>
                </td>
            </tr>
            <tr>
                <th>Data</th>
                <td>
                    <xsl:value-of select="tei:date"/>
                </td>
            </tr>
            <tr>
                <th>Risorsa XML</th>
                <td>
                    <xsl:value-of select="tei:idno"/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <!--Template per address-->
    <xsl:template match="tei:address">
        <xsl:for-each select="*">
            <xsl:value-of select="." />
            <!-- Inserisce una virgola e uno spazio dopo ogni elemento tranne l'ultimo -->
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--Template per le parole in corsivo-->
    <xsl:template match="text()[ancestor::*[@rend='italics']]">
        <i><xsl:value-of select="."/></i>
    </xsl:template>

    <!-- Template per gli elementi TEI con attributo ref -->
    <xsl:template match="tei:*[@ref]">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@ref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <!-- Template per i nomi di persona e le reference a quelle persone-->
    <xsl:template match="tei:persName[@corresp]">
        <!-- Trova l'ID della persona -->
        <xsl:variable name="person-id" select="substring-after(@corresp, '#')"/>
        
        <!-- Trova la persona nella listPerson usando l'ID -->
        <xsl:variable name="person" select="/tei:TEI/tei:text/tei:back/tei:div/tei:listPerson/tei:person[@xml:id=$person-id]"/>
        
        <!-- Mostra il nome breve nel testo con link se presente -->
        <xsl:choose>
            <xsl:when test="$person/tei:persName/tei:ref/@target">
                <span class="nome_testo">
                    <a href="{$person/tei:persName/tei:ref/@target}">
                        <xsl:apply-templates select="." mode="short"/>
                    </a>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="nome_testo">
                    <xsl:apply-templates select="." mode="short"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:if test="$person">
            <span class="nomi">
                <ul>
                    <li>
                        <strong>Nome completo: </strong>
                        <xsl:for-each select="$person/tei:persName/*">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </li>
                    
                    <xsl:if test="$person/tei:occupation">
                        <li>
                            <strong>Occupazione: </strong>
                            <xsl:value-of select="$person/tei:occupation"/>
                        </li>
                    </xsl:if>

                    <xsl:if test="$person/tei:note">
                        <li>
                            <strong>Note: </strong>
                            <xsl:value-of select="$person/tei:note"/>
                        </li>
                    </xsl:if>
                    
                    <xsl:if test="$person/tei:birth/tei:date">
                        <li>
                            <strong>Data di nascita: </strong>
                            <xsl:value-of select="$person/tei:birth/tei:date"/>
                        </li>
                    </xsl:if>
                    
                    <xsl:if test="$person/tei:birth/tei:placeName">
                        <li>
                            <strong>Luogo di nascita: </strong>
                            <xsl:value-of select="$person/tei:birth/tei:placeName"/>
                            <xsl:for-each select="$person/tei:birth/tei:location/*">
                                , <xsl:value-of select="."/>
                            </xsl:for-each>
                        </li>
                    </xsl:if>
                    
                    <xsl:if test="$person/tei:death/tei:date">
                        <li>
                            <strong>Data di morte: </strong>
                            <xsl:value-of select="$person/tei:death/tei:date"/>
                        </li>
                    </xsl:if>
                    
                    <xsl:if test="$person/tei:death/tei:placeName">
                        <li>
                            <strong>Luogo di morte: </strong>
                            <xsl:value-of select="$person/tei:death/tei:placeName"/>
                            <xsl:for-each select="$person/tei:death/tei:location/*">
                                , <xsl:value-of select="."/>
                            </xsl:for-each>
                        </li>
                    </xsl:if>
                </ul>
            </span>
        </xsl:if>
    </xsl:template>
    
    <!-- Template per visualizzare solo il nome breve in modalità "short" -->
    <xsl:template match="tei:persName" mode="short">
        <xsl:for-each select="*">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--Template per visualizzare gli elementi figlio di tei:persName-->
    <xsl:template match="tei:persName/*" mode="short">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- Template per luoghi -->
    <xsl:template match="tei:placeName[@corresp] | tei:geogName[@corresp]">
        <xsl:variable name="luogo-id" select="substring-after(@corresp, '#')"/>
        <xsl:variable name="luogo" select="/tei:TEI/tei:text/tei:back/tei:div/tei:listPlace/tei:place[@xml:id=$luogo-id]"/>
        <xsl:choose>
            <xsl:when test="$luogo/tei:geogName/tei:ref/@target">
                <span class="nome_testo">
                    <a href="{$luogo/tei:geogName/tei:ref/@target}">
                        <xsl:apply-templates select="." mode="short"/>
                    </a>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$luogo/tei:placeName/tei:ref/@target">
                        <span class="nome_testo">
                            <a href="{$luogo/tei:placeName/tei:ref/@target}">
                                <xsl:apply-templates select="." mode="short"/>
                            </a>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="nome_testo">
                            <xsl:apply-templates select="." mode="short"/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="$luogo">
            <span class="nomi nome_luogo">
                <ul>
                    <li>
                        <strong>Nome: </strong>
                        <xsl:for-each select="$luogo/tei:placeName | $luogo/tei:geogName">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </li>
                    
                    <xsl:if test="$luogo/tei:location/tei:region">
                        <li>
                            <strong>Regione: </strong>
                            <xsl:value-of select="$luogo/tei:location/tei:region"/>
                        </li>
                    </xsl:if>
                    
                    <xsl:if test="$luogo/tei:location/tei:country">
                        <li>
                            <strong>Paese: </strong>
                            <xsl:value-of select="$luogo/tei:location/tei:country"/>
                        </li>
                    </xsl:if>

                    <xsl:if test="$luogo/tei:note">
                        <li>
                            <strong>Note: </strong>
                            <xsl:value-of select="$luogo/tei:note"/>
                        </li>
                    </xsl:if>
                </ul>
            </span>
        </xsl:if>
    </xsl:template>

    <!-- Template per visualizzare solo il nome breve in modalità "short" -->
    <xsl:template match="tei:placeName | tei:geogName" mode="short">
        <xsl:value-of select="."/>
    </xsl:template>

    <!--Template per le organizzazioni-->
    <xsl:template match="tei:orgName[@corresp]">
        <xsl:variable name="org-id" select="substring-after(@corresp, '#')"/>
        <xsl:variable name="org" select="/tei:TEI/tei:text/tei:back/tei:div/tei:listOrg/tei:org[@xml:id=$org-id]"/>
        <xsl:choose>
            <xsl:when test="$org/tei:orgName/tei:ref/@target">
                <span class="nome_testo">
                    <a href="{$org/tei:orgName/tei:ref/@target}">
                        <xsl:apply-templates select="." mode="short"/>
                    </a>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="nome_testo">
                    <xsl:apply-templates select="." mode="short"/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$org">
            <span class="nomi nome_org">
                <ul>
                    <li>
                        <strong>Nome: </strong>
                        <xsl:for-each select="$org/tei:orgName">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </li>
                    
                    <xsl:if test="$org/@role">
                        <li>
                            <strong>Ruolo: </strong>
                            <xsl:value-of select="$org/@role"/>
                        </li>
                    </xsl:if>
        
                    <xsl:if test="$org/tei:note">
                        <li>
                            <strong>Note: </strong>
                            <xsl:value-of select="$org/tei:note"/>
                        </li>
                    </xsl:if>

                    <xsl:if test="$org/tei:desc">
                        <li>
                            <strong>Descrizione: </strong>
                            <xsl:value-of select="$org/tei:desc"/>
                        </li>
                    </xsl:if>
                </ul>
            </span>
        </xsl:if>
    </xsl:template>

    <!-- Template per visualizzare solo il nome breve in modalità "short" -->
    <xsl:template match="tei:orgName" mode="short">
        <xsl:value-of select="."/>
    </xsl:template>


</xsl:stylesheet>