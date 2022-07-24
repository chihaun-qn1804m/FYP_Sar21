using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;
using Photon.Pun;
using UnityEngine.XR.Interaction.Toolkit;

public class NetworkPlayer : MonoBehaviour
{
    public Transform head;
    public Transform playerPosition;
    public Transform leftHand;
    public Transform rightHand;
    public Transform playerRotation;
    // public Transform leftLeg;
    // public Transform rightLeg;
    private PhotonView photonView;

    private Transform headRig;
    private Transform leftHandRig;
    private Transform rightHandRig;
    private Transform playerPositionRig;
    private Transform playerRotationRig;
    // private Transform leftLegRig;
    // private Transform rightLegRig;

    // Start is called before the first frame update
    void Start()
    {
        photonView = GetComponent<PhotonView>();

        XRRig rig = FindObjectOfType<XRRig>();
        playerPositionRig = rig.transform.Find("PlayerController");
        playerRotationRig = rig.transform.Find("PlayerController/CameraRig/TrackingSpace/CenterEyeAnchor/IKHeadTarget");
        headRig = rig.transform.Find("PlayerController/CameraRig/TrackingSpace/CenterEyeAnchor");
        leftHandRig = rig.transform.Find("PlayerController/CameraRig/TrackingSpace/LeftHandAnchor/LeftControllerAnchor/LeftController");
        rightHandRig = rig.transform.Find("PlayerController/CameraRig/TrackingSpace/RightHandAnchor/RightControllerAnchor/RightController");
        // leftLegRig = rig.transform.Find("PlayerController/CameraRig/TrackingSpace/LeftHandAnchor/LeftControllerAnchor/LeftLeg");
        // rightLegRig = rig.transform.Find("PlayerController/CameraRig/TrackingSpace/RightHandAnchor/RightControllerAnchor/RightLeg");
    }

    // Update is called once per frame
    void Update()
    {
        if(photonView.IsMine)
        {
            rightHand.gameObject.SetActive(false);
            leftHand.gameObject.SetActive(false);
            playerPosition.gameObject.SetActive(false);
            playerRotation.gameObject.SetActive(false);
            // head.gameObject.SetActive(false);
            // leftLeg.gameObject.SetActive(false);
            // rightLeg.gameObject.SetActive(false);
            MapPosition(playerPosition, playerPositionRig, headRig);
            MapPositionRotation(head, headRig);
            MapPositionRotation(leftHand, leftHandRig);
            MapPositionRotation(rightHand, rightHandRig);
            MapPositionRotation(playerRotation, playerRotationRig);
            // MapPosition(leftLeg, leftLegRig);
            // MapPosition(rightLeg, rightLegRig);
        }
    }

    void MapPositionRotation(Transform target, Transform rigTransform)
    {
        target.position = rigTransform.position;
        target.rotation = rigTransform.rotation;
    }
    void MapPosition(Transform target, Transform rigTransform, Transform headRigPos)
    {
        target.position = new Vector3(rigTransform.position.x,headRigPos.position.y , rigTransform.position.z);
        target.rotation = rigTransform.rotation;

    }
}
