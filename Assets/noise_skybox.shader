Shader "Custom/noise_skybox"
{
    Properties {
        _Pulse ("Pulse", Float) = 0.0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Background"
            "Queue"="Background"
            "PreviewType"="SkyBox"
        }

        Pass
        {
            ZWrite Off
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            uniform float _Pulse;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float3 texcoord : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                return o;
            }

            float random(half2 st) {
                return frac(sin(dot(st.xy, half2(12.9898,78.233)))*43758.5453123);
            }
            
            float noise(half2 st) {
                half2 i = floor(st);
                half2 f = frac(st);
                
                float a = random(i + half2(0.0, 0.0));
                float b = random(i + half2(1.0, 0.0));
                float c = random(i + half2(0.0, 1.0));
                float d = random(i + half2(1.0, 1.0));
                
                half2 u = f * f * (3.0 - 2.0 * f);
                
                float result = lerp(a, b, u.x) + (c-a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
                
                return result;
            }
            
            float fbm(half2 st) {
                float value = 0.0;
                float amplitude = .5;
                float frequency = 0.0;
	
                for (int i = 0; i < 6; i++) {
                    value += amplitude * noise(st);
                    st *= 2.0;
                    amplitude *= 0.5;
                }
                return value;
            }

            fixed3 gradient(float2 p) {
                return fixed3(0.4, abs(p.x * 0.15), 0.1) * _Pulse;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 resolution = _ScreenParams;
                float2 coord = i.texcoord.xy * resolution;
                half2 p = (coord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
                half3 color = half3(0.0, 0.0, 0.0);
                
                color += fbm(p + fbm(p * 2.0) + _SinTime);

                color += gradient(p);

                return float4( color, 1.0 );
            }
            ENDCG
        }
    }
}