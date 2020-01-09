<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs dc t"
    version="2.0">
   
    <xsl:template match="t:teiHeader">
        <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
            <fileDesc><titleStmt>
                <title><xsl:value-of select="//dc:title[1]"/></title>
                <author><xsl:value-of select="//dc:creator[1]"/></author>                
            </titleStmt>
            <sourceDesc>
                <bibl type="printSource"><date><xsl:value-of select="//dc:date[1]"/></date></bibl>
            </sourceDesc>
            </fileDesc>
        </teiHeader>
    </xsl:template>
    
    <xsl:template match="t:div[starts-with(@n,'CHAPITRE')]">
        <div xmlns="http://www.tei-c.org/ns/1.0" type="chapter">
            <head>
                <xsl:value-of select="t:p[1]"/>
            </head>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
  
  <xsl:template match="@rend[.='calibre']"/>

<xsl:template match="t:emph">
    <hi xmlns="http://www.tei-c.org/ns/1.0">
        <xsl:apply-templates/>
    </hi>
</xsl:template>

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