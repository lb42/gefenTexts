<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:t="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs dc t e" version="2.0">

    <xsl:variable name="today">
        <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    </xsl:variable>

    <xsl:param name="textId"/>
    <xsl:param name="textDate"/>
    <xsl:variable name="fullTitle">
        <xsl:value-of select="document('meta.xml')//bibl[@xml:id=$textId]/title[2]"/>
    </xsl:variable>
    <xsl:variable name="authSex">
        <xsl:value-of select="document('meta.xml')//bibl[@xml:id=$textId]/sex"/>      
    </xsl:variable>
    
    <xsl:variable name="wordCount">
        <xsl:value-of
            select="
                string-length(normalize-space(//t:body))
                -
                string-length(translate(normalize-space(//t:body), ' ', '')) + 1"
        />
    </xsl:variable>
    <xsl:variable name="timeSlot">
        <xsl:choose>
            <xsl:when test="$textDate le '1859'">T1</xsl:when>
            <xsl:when test="$textDate le '1879'">T2</xsl:when>
            <xsl:when test="$textDate le '1899'">T3</xsl:when>
            <xsl:when test="$textDate le '1920'">T4</xsl:when>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="size">
        <xsl:choose>
            <xsl:when test="xs:integer($wordCount) le 50000">short</xsl:when>
            <xsl:when test="xs:integer($wordCount) le 100000">medium</xsl:when>
            <xsl:when test="xs:integer($wordCount) gt 100000">long</xsl:when>
        </xsl:choose>
    </xsl:variable>

<xsl:variable name="sourceLink">
    <xsl:choose>
        <xsl:when test="t:TEI/t:teiHeader/t:metadata/dc:identifier[starts-with(.,'URI')]">
            <xsl:value-of select="substring-after(t:TEI/t:teiHeader/t:metadata/dc:identifier[starts-with(.,'URI')],'URI')"/>
        </xsl:when>
        <xsl:when test="t:TEI/t:teiHeader/t:metadata/dc:source">
            <xsl:value-of select="//dc:source"/>
        </xsl:when>
        <xsl:otherwise><xsl:text>#unknownSource</xsl:text></xsl:otherwise>
    </xsl:choose>
</xsl:variable>
    <!-- replace schema pi -->

    <xsl:template match="processing-instruction(xml-model)"/>

    <xsl:template match="t:TEI">
        <xsl:message>
            <xsl:value-of select="concat($textId,' is ', $fullTitle)"/></xsl:message>       
        <xsl:text>
    </xsl:text>
        <xsl:processing-instruction name="xml-model">
            href="../../Schemas/eltec-1.rng" type="application/xml" 
            schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:text>
    </xsl:text>
        <xsl:processing-instruction name="xml-model">
            href="../../Schemas/eltec-1.rng" type="application/xml" 
            schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <xsl:text>
</xsl:text>
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:e="http://distantreading.net/eltec/ns"
            xml:id="{$textId}" xml:lang="fr">
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>

    <xsl:template match="t:teiHeader">
        <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
            <fileDesc>
                <titleStmt>
                    <title>
                        <xsl:value-of select="$fullTitle"/>
                    </title>
                    <author>
                        <xsl:attribute name="ref">
                            <xsl:value-of select="document('meta.xml')//bibl[@xml:id=$textId]/author/@ref"/>
                        </xsl:attribute>
                        <xsl:value-of select="document('meta.xml')//bibl[@xml:id=$textId]/author"/>                      
                    </author>
                </titleStmt>
                <extent>
                    <xsl:comment>an upper estimate: includes paratext </xsl:comment>
                    <measure unit="words">
                        <xsl:value-of select="$wordCount"/>
                    </measure>
                </extent>
                <publicationStmt>
                    <p>à fournir</p>
                </publicationStmt>
                <sourceDesc>
                    <bibl type="printSource">
                        <author>
                            <xsl:value-of select="document('meta.xml')//bibl[@xml:id=$textId]/author"/>
                        </author>
                        <title><xsl:value-of select="//dc:title"/></title>
                        <date>
                            <xsl:value-of select="$textDate"/>
                        </date>
                    </bibl>
                    <bibl type="digitalSource">
                        <publisher><xsl:value-of select="//dc:publisher"/></publisher>
                        <ref target="{$sourceLink}">
                            <xsl:value-of select="$sourceLink"/>
                        </ref>
                    </bibl>
                </sourceDesc>
            </fileDesc>
            <encodingDesc n="eltec-1">
                <p/>
            </encodingDesc>
            <profileDesc>
                <langUsage>
                    <language ident="fr"/>
                </langUsage>
                <textDesc>
                    <!-- a corriger -->
                    <e:authorGender xmlns="http://distantreading.net/eltec/ns" key="{$authSex}"/>
                    <e:size xmlns="http://distantreading.net/eltec/ns" key="{$size}"/>
                    <e:reprintCount xmlns="http://distantreading.net/eltec/ns" key="unspecified"/>
                    <e:timeSlot xmlns="http://distantreading.net/eltec/ns" key="{$timeSlot}"/>
                </textDesc>
            </profileDesc>
            <revisionDesc>
                <change when="{$today}">entête auto-généré: à compléter </change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>

    <!-- things we suppress -->
    <!-- all lb, all @rend -->
    <xsl:template match="t:lb"/>
    <xsl:template match="@rend"/>
    <xsl:template match="t:div[matches(@rend, 'pgheader')]" priority="99"/>
    <xsl:template match="t:div[starts-with(@n, 'À propos')]" priority="99"/>
    <xsl:template match="t:div[contains(@n, 'LICENSE')]" priority="99"/>
    <xsl:template match="t:div[starts-with(@n, 'Fin')]" priority="99"/>
    <xsl:template match="t:p[string-length(normalize-space(.)) le 1]" priority="99"/>
    <xsl:template match="t:head/@type"/>
    
    
    <!-- things we copy -->

    <!--<xsl:template match="t:body/t:div[not(@n)]">
        <xsl:comment>Untyped div found...</xsl:comment>
        <xsl:apply-templates/>
    </xsl:template>
-->
    <xsl:template match="t:div[starts-with(@n, 'Page')]" priority="2">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="titlepage">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="t:div[starts-with(@n, 'PRÉFACE')]"  priority="2">>
        <div xmlns="http://www.tei-c.org/ns/1.0" type="liminal">
            <head>
                <xsl:apply-templates select="t:p[1]"/>
            </head>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="t:div[starts-with(@n, 'PRÉFACE')]/t:p[1]"/>

    <xsl:template match="t:div[starts-with(@n, 'CHAPITRE') or starts-with(@n, 'Chapitre')]"  priority="2">
  <!-- <xsl:message>Found a chapter</xsl:message>
  -->    <div xmlns="http://www.tei-c.org/ns/1.0" type="chapter">
     <xsl:if test="not(t:head)">
           <head>        
                <xsl:value-of select="t:p[1]"/>
            </head>
        </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="t:div[starts-with(@n, 'Chapitre')]/t:p[1]"/>
     <xsl:template match="t:div[starts-with(@n, 'CHAPITRE')]/t:p[1]"/>

<!-- things we detag -->
    
<xsl:template match="t:div[not(@rend='toc')]">
    <xsl:apply-templates/>
</xsl:template>
    <xsl:template match="t:head/t:ref">
        <xsl:apply-templates/>
    </xsl:template>
 
    <xsl:template match="t:hi[@rend='sup']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="t:hi/t:hi">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="t:seg[matches(normalize-space(.), '[A-Z]')]">
        <xsl:apply-templates/>        
    </xsl:template>
    
    <!-- things we retag -->
    
    <xsl:template match="t:p[t:seg[matches(normalize-space(.), '[A-Z][A-Z ]+')]]" priority="99">
        <head><xsl:value-of select="." /></head>        
    </xsl:template>
     

    <xsl:template match="t:seg">
        <xsl:if test="string-length(normalize-space(.)) gt 0 ">
            <hi xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:apply-templates/>
            </hi>
        </xsl:if>
    </xsl:template>

    <xsl:template match="t:emph">
        <hi xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </hi>
    </xsl:template>
    
    
    <xsl:template match="t:graphic">
        <gap unit="graphic" xmlns="http://www.tei-c.org/ns/1.0"/>
    </xsl:template>

<xsl:template match="t:quote">
    <l xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:apply-templates/>
    </l>
</xsl:template>
    
    <!-- notes -->
    
    <xsl:template match="t:p[t:ref]" priority="3">
        <note>
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat($textId,'_N',substring-before(substring-after(t:ref[1],'['),']'))"/>
            </xsl:attribute>
<xsl:apply-templates/>
        </note>
    </xsl:template>
    <xsl:template match="t:p/t:ref" priority="10"/>

<xsl:template match="t:p//t:ref">
    <ref>
        <xsl:attribute name="target">
            <xsl:value-of select="concat('#',$textId,'_N',substring-before(substring-after(.,'['),']'))"/>
        </xsl:attribute>
    </ref>
</xsl:template>
<!-- special cases -->
    
   <!-- <xsl:template match="t:p[t:hi[1] and not(matches(text()[1], '[a-z]+'))]">
        <l><xsl:value-of select="t:hi"/></l>
    </xsl:template>-->
    
    <xsl:template match="t:p[t:emph[1] and not(matches(text()[1], '[a-zA-Z]+'))]">
        <l><xsl:value-of select="t:emph"/></l>
    </xsl:template>
    
    <xsl:template match="t:p[not(matches(., '[a-z]+'))]" priority="2">
  <!--      eq '††']">
  -->      <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="subchapter"/>
    </xsl:template>



    <!-- gutenberg specific -->
    
    <xsl:template match="t:div[matches(@n, '^[IVX]+$')]" priority="10">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="chapter">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

  
   <xsl:template match="t:div[@type='section']">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="chapter">
           <xsl:apply-templates/>
        </div> 
    </xsl:template>
    
   
<!-- copy everything else -->
    
    <xsl:template match="* | @* | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
        <!-- could normalize() here -->
    </xsl:template>
</xsl:stylesheet>
