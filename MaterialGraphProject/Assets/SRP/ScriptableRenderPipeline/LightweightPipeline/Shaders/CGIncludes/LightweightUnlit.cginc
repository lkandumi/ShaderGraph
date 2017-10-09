﻿#ifndef LIGHTWEIGHT_UNLIT_INCLUDED
#define LIGHTWEIGHT_UNLIT_INCLUDED

struct appdata_unlit
{
	float4 vertex : POSITION;
	float4 texcoord0 : TEXCOORD0;
#ifdef VERTINPUT_CUSTOM
	VERTINPUT_CUSTOM;
#endif
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct LightweightVertexOutputUnlit
{
	float4 meshUV0 : TEXCOORD0;
	UNITY_FOG_COORDS(1)
	float4 vertex : SV_POSITION;
#ifdef VERTOUTPUT_CUSTOM
	VERTOUTPUT_CUSTOM
#endif
	UNITY_VERTEX_OUTPUT_STEREO
};

struct SurfaceUnlit
{
	float3 Color;     // color
	float Alpha;        // alpha for transparencies
};

SurfaceUnlit InitializeSurfaceUnlit()
{
	SurfaceUnlit s;
	s.Color = float3(0.5, 0.5, 0.5);
	s.Alpha = 1;
	return s;
}

void DefineSurface(LightweightVertexOutputUnlit i, inout SurfaceUnlit s);

sampler2D _MainTex;
float4 _MainTex_ST;
half4 _Color;
half _Cutoff;

LightweightVertexOutputUnlit LightweightVertexUnlit(appdata_unlit v)
{
	LightweightVertexOutputUnlit o;

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

#ifdef VERTEX_CUSTOM
	VERTEX_CUSTOM;
#endif

    o.vertex = UnityObjectToClipPos(v.vertex);
	o.meshUV0 = float4(0, 0, 0, 0);
	o.meshUV0.xy = v.texcoord0.xy;// TRANSFORM_TEX(v.texcoord0, _MainTex);
    UNITY_TRANSFER_FOG(o,o.vertex);
    return o;
}

half4 LightweightFragmentUnlit(LightweightVertexOutputUnlit i) : SV_Target
{
	SurfaceUnlit s = InitializeSurfaceUnlit();
	DefineSurface(i, s);

	UNITY_APPLY_FOG(i.fogCoord, s.Color);

#ifdef _ALPHABLEND_ON
	return fixed4(s.Color, s.Alpha);
#else
	return fixed4(s.Color, 1.0);
#endif
};

#endif