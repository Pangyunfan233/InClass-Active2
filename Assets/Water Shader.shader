Shader "Custom/URP_WaterShader"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (0, 1, 1, 1)
        _MainTex ("Water Texture", 2D) = "white" {}
        _Freq ("Wave Frequency", Range(0, 5)) = 3.0
        _Speed ("Wave Speed", Range(0, 10)) = 1.0
        _Amp ("Wave Amplitude", Range(0, 1)) = 0.1
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

            float4 _BaseColor; TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex);
            float _Freq, _Speed, _Amp;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                float wave = sin(_Time.y * _Speed + IN.positionOS.x * _Freq) * _Amp;
                float3 displacedPos = IN.positionOS.xyz;
                displacedPos.y += wave;
                OUT.positionHCS = TransformObjectToHClip(displacedPos);
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                half4 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);
                return texColor * _BaseColor;
            }
            ENDHLSL
        }
    }
}