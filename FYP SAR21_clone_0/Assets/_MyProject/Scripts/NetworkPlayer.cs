using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;
using Photon.Pun;
using UnityEngine.XR.Interaction.Toolkit;

public class NetworkPlayer : MonoBehaviour
{
    public Transform head;
    public Transform leftHand;
    public Transform rightHand;
    public Transform body;
    private PhotonView photonView;

    private Transform headRig;
    private Transform leftHandRig;
    private Transform rightHandRig;
    private Transform bodyRig;

    // Start is called before the first frame update
    void Start()
    {
        photonView = GetComponent<PhotonView>();

        XRRig rig = FindObjectOfType<XRRig>();
        headRig = rig.transform.Find("PlayerController/CameraRig/TrackingSpace/CenterEyeAnchor");
        leftHandRig = rig.transform.Find("PlayerController/CameraRig/TrackingSpace/LeftHandAnchor");
        rightHandRig = rig.transform.Find("PlayerController/CameraRig/TrackingSpace/RightHandAnchor");
        bodyRig = rig.transform.Find("BodyIK");
    
    }

    // Update is called once per frame
    void Update()
    {
        if(photonView.IsMine)
        {
            rightHand.gameObject.SetActive(false);
            leftHand.gameObject.SetActive(false);
            head.gameObject.SetActive(false);
            body.gameObject.SetActive(false);

            MapPosition(head, headRig);
            MapPosition(leftHand, leftHandRig);
            MapPosition(rightHand, rightHandRig);
            MapPosition(body, bodyRig);
        }
    }

    void MapPosition(Transform target, Transform rigTransform)
    {
        target.position = rigTransform.position;
        target.rotation = rigTransform.rotation;
    }

}
