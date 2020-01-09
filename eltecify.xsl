<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" 
    exclude-result-prefixes="xs dc t e"
    version="2.0">
    
    <xsl:variable name="today">
        <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    </xsl:variable>
    
   <xsl:param name="textId">FRXXXXX</xsl:param>
    
    <!-- replace schema pi -->
    
    <xsl:template match="processing-instruction(xml-model)"/>
  
    <xsl:template match="t:TEI">
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
        <TEI xmlns="http://www.tei-c.org/ns/1.0" 
            xmlns:e="http://distantreading.net/eltec/ns" 
            xml:id="{$textId}" xml:lang="fr">
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>
    
    <xsl:template match="t:teiHeader">
        <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
            <fileDesc><titleStmt>
                <title><xsl:value-of select="//dc:title[1]"/></title>
                <author><xsl:value-of select="//dc:creator[1]"/></author>                
            </titleStmt>
                <extent>
                    <measure unit="words">999999999</measure>
                </extent>
                <publicationStmt>
                    <p>Notices d'edition</p>
                </publicationStmt>
            <sourceDesc>
                <bibl type="printSource"><date><xsl:value-of select="substring-before(//dc:date[1],'T')"/></date></bibl>
                <bibl type="digitalSource">A COMPLETER</bibl>
            </sourceDesc>
            </fileDesc>
            <encodingDesc n="eltec-0">
                <p/>
            </encodingDesc>
            <profileDesc>
                <langUsage>
                    <language ident="fr"/>
                </langUsage>
                <textDesc>
                    <!-- a corriger -->
                    <e:authorGender xmlns="http://distantreading.net/eltec/ns" key="F"/>
                    <e:size xmlns="http://distantreading.net/eltec/ns" key="short"/>
                    <e:canonicity xmlns="http://distantreading.net/eltec/ns" key="unspecified"/>
                    <e:timeSlot xmlns="http://distantreading.net/eltec/ns" key="T4"/>
                </textDesc>
            </profileDesc>
            <revisionDesc>
                <change when="{$today}">Auto generation de l'entete: a completer </change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>
    
    <xsl:template match="t:lb"/>
    
    <xsl:template match="t:body/t:div[not(@n)]">
        <xsl:apply-templates/>
        
    </xsl:template>
    
 <!-- calibre source -->   
    <xsl:template match="t:div[starts-with(@n,'Chapitre')]">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="chapter">
            <head>
                <xsl:value-of select="t:p[1]"/>
            </head>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="t:div[starts-with(@n,'Chapitre')]/t:p[1]"/>
 
    <!--xsl:template match="t:p[@rend='calibrec']"/-->
    <xsl:template match="@rend[.='calibre']"/>
    
<xsl:template match="t:emph">
    <hi xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:apply-templates/>
    </hi>
</xsl:template>
    
    <xsl:template match="t:seg">
        <xsl:if test="string-length(normalize-space(.)) gt 1">
        <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="t:p[string-length(normalize-space(.)) le 1] "/>
        
        <xsl:template match="t:graphic">
            <gap unit="graphic" xmlns="http://www.tei-c.org/ns/1.0"/>
        </xsl:template>
    
    <!-- gutenberg source -->
    
    <xsl:template match="t:div[matches(@n,'^[IVX]+$')]">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="chapter">
    <xsl:apply-templates/>
        </div></xsl:template>
    
    <xsl:template match="t:head/@type"/>
    
    <xsl:template match="t:div[matches(@rend, 'pgheader')]"/>

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