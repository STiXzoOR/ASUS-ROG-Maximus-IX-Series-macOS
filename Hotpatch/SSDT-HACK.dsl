// Custom configuration for ASUS ROG Maximus IX series motherboards

DefinitionBlock ("", "SSDT", 2, "hack", "asusrogix", 0)
{
    Device(RMCF)
    {
        Name(_ADR, 0)   // do not remove
    }
    
    #define NO_DEFINITIONBLOCK
    #include "Downloads/SSDT-XOSI.dsl"
    #include "Downloads/SSDT-SATA.dsl"
    #include "SSDT-UIAC.dsl"
}
//EOF