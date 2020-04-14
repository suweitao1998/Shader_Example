Shader "2/2l_loading"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Speed", float) = 20
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            fixed _Speed;

            fixed4 frag (v2f i) : SV_Target
            {
                // 裁剪圆形
                clip(step(0, 1 - length(1 - 2 * i.uv)) - 0.1);

                // 旋转
                float2 uv = i.uv;
                uv -= 0.5;
                float angle = _Time.x * _Speed;
                float2 rotUV = float2(0,0);
                rotUV.x = uv.x * cos(angle) - uv.y * sin(angle);
                rotUV.y = uv.x * sin(angle) + uv.y * cos(angle);
                rotUV += 0.5;

                // 应用旋转后的uv
                fixed4 col = tex2D(_MainTex, rotUV);
                return col;
            }
            ENDCG
        }
    }
}
