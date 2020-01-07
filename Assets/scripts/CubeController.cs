using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeController : MonoBehaviour {

    private GameObject _materialController;
    private SkyboxController _controllerScript;

    // Start is called before the first frame update
    void Start () {
        _materialController = GameObject.Find ("MaterialController");
        _controllerScript = _materialController.GetComponent<SkyboxController>();
    }

    // Update is called once per frame
    void Update () {

    }

    public void OnPressed () {
        _controllerScript.OnPressed ();
    }
}