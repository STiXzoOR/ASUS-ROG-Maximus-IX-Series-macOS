// Custom configuration for ASUS ROG Maximus IX series motherboards

DefinitionBlock ("", "SSDT", 2, "hack", "asusrog", 0)
{
    Device(RMCF)
    {
        Name(_ADR, 0)   // do not remove
        
        // AUDL: Audio Layout
        //
        // The value here will be used to inject layout-id for HDEF and HDAU
        // If set to Ones, no audio injection will be done.
        Name(AUDL, 11)
    }
    
    #define NO_DEFINITIONBLOCK
    #include "Downloads/SSDT-HDEF.dsl"
    #include "Downloads/SSDT-XOSI.dsl"
    #include "Downloads/SSDT-SATA.dsl"
    #include "SSDT-UIAC.dsl"
}
//EOF