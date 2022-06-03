using UnityEngine;
using UnityEngine.Events;

namespace DuloGames.UI
{
    public class UIInputEvent : MonoBehaviour
    {
        #pragma warning disable 0649
        [SerializeField] private string m_InputName;

        [SerializeField] private UnityEvent m_OnButton = new UnityEvent();
        [SerializeField] private UnityEvent m_OnButtonDown = new UnityEvent();
        [SerializeField] private UnityEvent m_OnButtonUp = new UnityEvent();
        #pragma warning restore 0649

        protected void Update()
        {
            if (!this.isActiveAndEnabled || !this.gameObject.activeInHierarchy || string.IsNullOrEmpty(this.m_InputName))
                return;

            if (Input.GetButton(this.m_InputName))
                this.m_OnButton.Invoke();

            if (Input.GetButtonDown(this.m_InputName))
                this.m_OnButtonDown.Invoke();

            if (Input.GetButtonUp(this.m_InputName))
                this.m_OnButtonUp.Invoke();
        }
    }
}
