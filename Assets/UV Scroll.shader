Shader "Custom/UVScroll"
{
    Properties
    {
        _MainTex ("Water", 2D) = "white" {}
        _FoamTex ("Foam", 2D) = "white" {}
        _ScrollX ("Scroll X", Range(-5,5)) = 1
        _ScrollY ("Scroll Y", Range(-5,5)) = 1
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalRenderPipeline" "RenderType" = "Opaque" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes { float4 positionOS : POSITION; float2 uv : TEXCOORD0; };
            struct Varyings { float4 positionHCS : SV_POSITION; float2 uv : TEXCOORD0; };

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            TEXTURE2D(_FoamTex); SAMPLER(sampler_FoamTex);
            float _ScrollX, _ScrollY;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float2 scrolledUV = IN.uv + float2(_ScrollX, _ScrollY) * _Time.y;
                float2 scrolledFoamUV = IN.uv + float2(_ScrollX, _ScrollY) * (_Time.y * 0.5);
                half4 water = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, scrolledUV);
                half4 foam = SAMPLE_TEXTURE2D(_FoamTex, sampler_FoamTex, scrolledFoamUV);
                return (water + foam) * 0.5;
            }
            ENDHLSL
        }
    }
}