Shader "Matrix Split"
{
	Properties
	{
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" "RenderPipeline" = "LightweightPipeline"}
		Tags
		{
			"RenderType"="Opaque"
			"Queue"="Geometry"
		}
		
		Pass
		{
			Tags{"LightMode" = "LightweightForward"}
			
					Blend One Zero
		
					Cull Back
		
					ZTest LEqual
		
					ZWrite On
		
			
		    HLSLPROGRAM
		    // Required to compile gles 2.0 with standard srp library
		    #pragma prefer_hlslcc gles
		    #pragma exclude_renderers d3d11_9x
		
		    #pragma vertex vert
		    #pragma fragment frag
		    #pragma multi_compile_fog
		    #pragma shader_feature _SAMPLE_GI
		    #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON
		    #pragma multi_compile_instancing
		
			#pragma vertex vert
		    #pragma fragment frag
		
		    // Lighting include is needed because of GI
		    #include "LWRP/ShaderLibrary/Core.hlsl"
		    #include "LWRP/ShaderLibrary/Lighting.hlsl"
		    #include "CoreRP/ShaderLibrary/Color.hlsl"
		    #include "LWRP/ShaderLibrary/InputSurfaceUnlit.hlsl"
		    #include "ShaderGraphLibrary/Functions.hlsl"
		
		    
		
		    					struct SurfaceInputs{
							};
					
					
					        void Unity_MatrixConstruction_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
					        {
					            Out4x4 = float4x4(M0.x, M1.x, M2.x, M3.x, M0.y, M1.y, M2.y, M3.y, M0.z, M1.z, M2.z, M3.z, M0.w, M1.w, M2.w, M3.w);
					            Out3x3 = float3x3(M0.x, M1.x, M2.x, M0.y, M1.y, M2.y, M0.z, M1.z, M2.z);
					            Out2x2 = float2x2(M0.x, M1.x, M0.y, M1.y);
					        }
					
					        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
					        {
					            RGBA = float4(R, G, B, A);
					            RGB = float3(R, G, B);
					            RG = float2(R, G);
					        }
					
							struct GraphVertexInput
							{
								float4 vertex : POSITION;
								float3 normal : NORMAL;
								float4 tangent : TANGENT;
								UNITY_VERTEX_INPUT_INSTANCE_ID
							};
					
							struct SurfaceDescription{
								float3 Color;
								float Alpha;
								float AlphaClipThreshold;
							};
					
							GraphVertexInput PopulateVertexData(GraphVertexInput v){
								return v;
							}
					
							SurfaceDescription PopulateSurfaceData(SurfaceInputs IN) {
								SurfaceDescription surface = (SurfaceDescription)0;
								float4x4 _MatrixConstruction_2AD19D82_4x4;
								float3x3 _MatrixConstruction_2AD19D82_3x3;
								float2x2 _MatrixConstruction_2AD19D82_2x2;
								Unity_MatrixConstruction_float(float4 (36,0,26,0), float4 (22,-2,0,0), float4 (3,4,28,0), float4 (24,0,0,0), _MatrixConstruction_2AD19D82_4x4, _MatrixConstruction_2AD19D82_3x3, _MatrixConstruction_2AD19D82_2x2);
								
								float4 _MatrixSplit_ACA62D32_M0 = _MatrixConstruction_2AD19D82_4x4[0];
								float4 _MatrixSplit_ACA62D32_M1 = _MatrixConstruction_2AD19D82_4x4[1];
								float4 _MatrixSplit_ACA62D32_M2 = _MatrixConstruction_2AD19D82_4x4[2];
								float4 _MatrixSplit_ACA62D32_M3 = _MatrixConstruction_2AD19D82_4x4[3];
								float4 _Combine_7C58675E_RGBA;
								float3 _Combine_7C58675E_RGB;
								float2 _Combine_7C58675E_RG;
								Unity_Combine_float((_MatrixSplit_ACA62D32_M0).x, (_MatrixSplit_ACA62D32_M1).x, (_MatrixSplit_ACA62D32_M2).x, (_MatrixSplit_ACA62D32_M3).x, _Combine_7C58675E_RGBA, _Combine_7C58675E_RGB, _Combine_7C58675E_RG);
								surface.Color = (_Combine_7C58675E_RGBA.xyz);
								surface.Alpha = 1;
								surface.AlphaClipThreshold = 0;
								return surface;
							}
					
		
		
		    struct GraphVertexOutput
		    {
		        float4 position : POSITION;
		        
		        UNITY_VERTEX_INPUT_INSTANCE_ID
		    };
		
		    GraphVertexOutput vert (GraphVertexInput v)
			{
			    v = PopulateVertexData(v);
				
		        GraphVertexOutput o = (GraphVertexOutput)0;
		        
		        UNITY_SETUP_INSTANCE_ID(v);
		        UNITY_TRANSFER_INSTANCE_ID(v, o);
		
		        o.position = TransformObjectToHClip(v.vertex.xyz);
		        
		        return o;
			}
		
		    half4 frag (GraphVertexOutput IN) : SV_Target
		    {
		        UNITY_SETUP_INSTANCE_ID(IN);
		
		    	
		    	
		        SurfaceInputs surfaceInput = (SurfaceInputs)0;
		        
		
		        SurfaceDescription surf = PopulateSurfaceData(surfaceInput);
		        float3 Color = float3(0.5, 0.5, 0.5);
		        float Alpha = 1;
		        float AlphaClipThreshold = 0;
							Color = surf.Color;
					Alpha = surf.Alpha;
					AlphaClipThreshold = surf.AlphaClipThreshold;
		
				
		#if _AlphaClip
		        clip(Alpha - AlphaClipThreshold);
		#endif
		    	return half4(Color, Alpha);
		    }
		    ENDHLSL
		}
		
		
		Pass
		{
			Tags{"LightMode" = "DepthOnly"}
		
			ZWrite On
			Cull Back
			ColorMask 0
		
			HLSLPROGRAM
			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma target 2.0
		
			#pragma vertex DepthOnlyVertex
			#pragma fragment DepthOnlyFragment
		
			// -------------------------------------
			// Material Keywords
			#pragma shader_feature _ALPHATEST_ON
		
			//--------------------------------------
			// GPU Instancing
			#pragma multi_compile_instancing
		
			#include "LWRP/ShaderLibrary/InputSurfaceUnlit.hlsl"
			#include "LWRP/ShaderLibrary/LightweightPassDepthOnly.hlsl"
			ENDHLSL
		}
		
	}
	
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		// Unlit shader always render in forward
		Pass
		{
		    Name "ForwardUnlit"
		    Tags { "LightMode" = "DepthForwardOnly" }
		
		    		Tags
				{
					"RenderType"="Opaque"
					"Queue"="Geometry"
				}
		
		    		Blend One Zero
		
		    		Cull Back
		
		    		ZTest LEqual
		
		    		ZWrite On
		
		
		    HLSLPROGRAM
		    
		    #pragma target 4.5
		    #pragma only_renderers d3d11 ps4 vulkan metal // TEMP: until we go further in dev
		    //#pragma enable_d3d11_debug_symbols
		
		    #pragma vertex Vert
		    #pragma fragment Frag
		
		    #define UNITY_MATERIAL_UNLIT // Need to be define before including Material.hlsl
		
		    #include "CoreRP/ShaderLibrary/common.hlsl"
		    #include "HDRP/ShaderVariables.hlsl"
		    #include "HDRP/ShaderPass/FragInputs.hlsl"
		    #include "HDRP/ShaderPass/ShaderPass.cs.hlsl"
		    #include "ShaderGraphLibrary/Functions.hlsl"
		
		    			#define SHADERPASS SHADERPASS_DEPTH_ONLY
		
		    
		    #include "HDRP/Material/Material.hlsl"
		
		    // This include will define the various Attributes/Varyings structure
		    #include "HDRP/ShaderPass/VaryingMesh.hlsl"
		
		    					struct SurfaceInputs{
							};
					
					
					        void Unity_MatrixConstruction_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
					        {
					            Out4x4 = float4x4(M0.x, M1.x, M2.x, M3.x, M0.y, M1.y, M2.y, M3.y, M0.z, M1.z, M2.z, M3.z, M0.w, M1.w, M2.w, M3.w);
					            Out3x3 = float3x3(M0.x, M1.x, M2.x, M0.y, M1.y, M2.y, M0.z, M1.z, M2.z);
					            Out2x2 = float2x2(M0.x, M1.x, M0.y, M1.y);
					        }
					
					        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
					        {
					            RGBA = float4(R, G, B, A);
					            RGB = float3(R, G, B);
					            RG = float2(R, G);
					        }
					
							struct SurfaceDescription{
								float3 Color;
								float Alpha;
							};
					
							SurfaceDescription PopulateSurfaceData(SurfaceInputs IN) {
								SurfaceDescription surface = (SurfaceDescription)0;
								float4x4 _MatrixConstruction_2AD19D82_4x4;
								float3x3 _MatrixConstruction_2AD19D82_3x3;
								float2x2 _MatrixConstruction_2AD19D82_2x2;
								Unity_MatrixConstruction_float(float4 (36,0,26,0), float4 (22,-2,0,0), float4 (3,4,28,0), float4 (24,0,0,0), _MatrixConstruction_2AD19D82_4x4, _MatrixConstruction_2AD19D82_3x3, _MatrixConstruction_2AD19D82_2x2);
								
								float4 _MatrixSplit_ACA62D32_M0 = _MatrixConstruction_2AD19D82_4x4[0];
								float4 _MatrixSplit_ACA62D32_M1 = _MatrixConstruction_2AD19D82_4x4[1];
								float4 _MatrixSplit_ACA62D32_M2 = _MatrixConstruction_2AD19D82_4x4[2];
								float4 _MatrixSplit_ACA62D32_M3 = _MatrixConstruction_2AD19D82_4x4[3];
								float4 _Combine_7C58675E_RGBA;
								float3 _Combine_7C58675E_RGB;
								float2 _Combine_7C58675E_RG;
								Unity_Combine_float((_MatrixSplit_ACA62D32_M0).x, (_MatrixSplit_ACA62D32_M1).x, (_MatrixSplit_ACA62D32_M2).x, (_MatrixSplit_ACA62D32_M3).x, _Combine_7C58675E_RGBA, _Combine_7C58675E_RGB, _Combine_7C58675E_RG);
								surface.Color = (_Combine_7C58675E_RGBA.xyz);
								surface.Alpha = 1;
								return surface;
							}
					
		
		
		    void GetSurfaceAndBuiltinData(FragInputs input, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
		    {
		        
		
		        SurfaceInputs surfaceInput;
		        
		
		        SurfaceDescription surf = PopulateSurfaceData(surfaceInput);
		        float3 Color = 0;
		        float Alpha = 0;
		        			Color = surf.Color;
					Alpha = surf.Alpha;
		
		        
		        surfaceData.color = Color;
		
		    #ifdef _ALPHATEST_ON
		        DoAlphaTest(Alpha, _AlphaCutoff);
		    #endif
		
		        // Builtin Data
		        builtinData.opacity = Alpha;
		        builtinData.bakeDiffuseLighting = float3(0.0, 0.0, 0.0);
		        builtinData.emissiveIntensity = 0; 
		        builtinData.emissiveColor = 0;
		        builtinData.velocity = float2(0.0, 0.0);
		        builtinData.shadowMask0 = 0.0;
		        builtinData.shadowMask1 = 0.0;
		        builtinData.shadowMask2 = 0.0;
		        builtinData.shadowMask3 = 0.0;
		        builtinData.distortion = float2(0.0, 0.0);
		        builtinData.distortionBlur = 0.0;
		        builtinData.depthOffset = 0.0;
		    }
		
		    #include "HDRP/ShaderPass/ShaderPassDepthOnly.hlsl"
		
		    ENDHLSL
		}
		// Unlit shader always render in forward
		Pass
		{
		    Name "ForwardUnlit"
		    Tags { "LightMode" = "ForwardOnly" }
		
		    		Tags
				{
					"RenderType"="Opaque"
					"Queue"="Geometry"
				}
		
		    		Blend One Zero
		
		    		Cull Back
		
		    		ZTest LEqual
		
		    		ZWrite On
		
		
		    HLSLPROGRAM
		    
		    #pragma target 4.5
		    #pragma only_renderers d3d11 ps4 vulkan metal // TEMP: until we go further in dev
		    //#pragma enable_d3d11_debug_symbols
		
		    #pragma vertex Vert
		    #pragma fragment Frag
		
		    #define UNITY_MATERIAL_UNLIT // Need to be define before including Material.hlsl
		
		    #include "CoreRP/ShaderLibrary/common.hlsl"
		    #include "HDRP/ShaderVariables.hlsl"
		    #include "HDRP/ShaderPass/FragInputs.hlsl"
		    #include "HDRP/ShaderPass/ShaderPass.cs.hlsl"
		    #include "ShaderGraphLibrary/Functions.hlsl"
		
		    			#define SHADERPASS SHADERPASS_FORWARD_UNLIT
		
		    
		    #include "HDRP/Material/Material.hlsl"
		
		    // This include will define the various Attributes/Varyings structure
		    #include "HDRP/ShaderPass/VaryingMesh.hlsl"
		
		    					struct SurfaceInputs{
							};
					
					
					        void Unity_MatrixConstruction_float (float4 M0, float4 M1, float4 M2, float4 M3, out float4x4 Out4x4, out float3x3 Out3x3, out float2x2 Out2x2)
					        {
					            Out4x4 = float4x4(M0.x, M1.x, M2.x, M3.x, M0.y, M1.y, M2.y, M3.y, M0.z, M1.z, M2.z, M3.z, M0.w, M1.w, M2.w, M3.w);
					            Out3x3 = float3x3(M0.x, M1.x, M2.x, M0.y, M1.y, M2.y, M0.z, M1.z, M2.z);
					            Out2x2 = float2x2(M0.x, M1.x, M0.y, M1.y);
					        }
					
					        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
					        {
					            RGBA = float4(R, G, B, A);
					            RGB = float3(R, G, B);
					            RG = float2(R, G);
					        }
					
							struct SurfaceDescription{
								float3 Color;
								float Alpha;
							};
					
							SurfaceDescription PopulateSurfaceData(SurfaceInputs IN) {
								SurfaceDescription surface = (SurfaceDescription)0;
								float4x4 _MatrixConstruction_2AD19D82_4x4;
								float3x3 _MatrixConstruction_2AD19D82_3x3;
								float2x2 _MatrixConstruction_2AD19D82_2x2;
								Unity_MatrixConstruction_float(float4 (36,0,26,0), float4 (22,-2,0,0), float4 (3,4,28,0), float4 (24,0,0,0), _MatrixConstruction_2AD19D82_4x4, _MatrixConstruction_2AD19D82_3x3, _MatrixConstruction_2AD19D82_2x2);
								
								float4 _MatrixSplit_ACA62D32_M0 = _MatrixConstruction_2AD19D82_4x4[0];
								float4 _MatrixSplit_ACA62D32_M1 = _MatrixConstruction_2AD19D82_4x4[1];
								float4 _MatrixSplit_ACA62D32_M2 = _MatrixConstruction_2AD19D82_4x4[2];
								float4 _MatrixSplit_ACA62D32_M3 = _MatrixConstruction_2AD19D82_4x4[3];
								float4 _Combine_7C58675E_RGBA;
								float3 _Combine_7C58675E_RGB;
								float2 _Combine_7C58675E_RG;
								Unity_Combine_float((_MatrixSplit_ACA62D32_M0).x, (_MatrixSplit_ACA62D32_M1).x, (_MatrixSplit_ACA62D32_M2).x, (_MatrixSplit_ACA62D32_M3).x, _Combine_7C58675E_RGBA, _Combine_7C58675E_RGB, _Combine_7C58675E_RG);
								surface.Color = (_Combine_7C58675E_RGBA.xyz);
								surface.Alpha = 1;
								return surface;
							}
					
		
		
		    void GetSurfaceAndBuiltinData(FragInputs input, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
		    {
		        
		
		        SurfaceInputs surfaceInput;
		        
		
		        SurfaceDescription surf = PopulateSurfaceData(surfaceInput);
		        float3 Color = 0;
		        float Alpha = 0;
		        			Color = surf.Color;
					Alpha = surf.Alpha;
		
		        
		        surfaceData.color = Color;
		
		    #ifdef _ALPHATEST_ON
		        DoAlphaTest(Alpha, _AlphaCutoff);
		    #endif
		
		        // Builtin Data
		        builtinData.opacity = Alpha;
		        builtinData.bakeDiffuseLighting = float3(0.0, 0.0, 0.0);
		        builtinData.emissiveIntensity = 0; 
		        builtinData.emissiveColor = 0;
		        builtinData.velocity = float2(0.0, 0.0);
		        builtinData.shadowMask0 = 0.0;
		        builtinData.shadowMask1 = 0.0;
		        builtinData.shadowMask2 = 0.0;
		        builtinData.shadowMask3 = 0.0;
		        builtinData.distortion = float2(0.0, 0.0);
		        builtinData.distortionBlur = 0.0;
		        builtinData.depthOffset = 0.0;
		    }
		
		    #include "HDRP/ShaderPass/ShaderPassForwardUnlit.hlsl"
		
		    ENDHLSL
		}
	}
	
	FallBack "Hidden/InternalErrorShader"
}
