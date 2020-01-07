using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkyboxController : MonoBehaviour {

    private Material skybox;
    private float pulse;
    private const float LAMBDA = 1.0f;
    private float time;
    // Start is called before the first frame update
    void Start () {
        skybox = new Material (RenderSettings.skybox);
        RenderSettings.skybox = skybox;
        pulse = 0.0f;
        time = 0.0f;
    }

    // Update is called once per frame
    void Update () {
        pulse = RenderSettings.skybox.GetFloat ("_Pulse");
        if (pulse > 0.01f) {
            pulse = pulse + Time.deltaTime * decay(time);
            RenderSettings.skybox.SetFloat ("_Pulse", pulse);
        }
        time += Time.deltaTime;
    }

    float decay(float x) {
        return -LAMBDA * Mathf.Exp(-LAMBDA * x);
    }

    public void OnPressed () {
        RenderSettings.skybox.SetFloat ("_Pulse", 1.0f);
        pulse = 1.0f;
        time = 0.0f;
    }

    void OnDestroy () {
        GameObject.Destroy (skybox);
    }
}