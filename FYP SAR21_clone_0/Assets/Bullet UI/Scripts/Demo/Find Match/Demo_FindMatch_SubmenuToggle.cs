using UnityEngine;
using UnityEngine.UI;

namespace DuloGames.UI
{
    [RequireComponent(typeof(Toggle))]
    public class Demo_FindMatch_SubmenuToggle : MonoBehaviour
    {
        #pragma warning disable 0649
        [SerializeField] private Demo_FindMatch_Info m_TargetInfo;
        #pragma warning restore 0649

        private Toggle m_Toggle;

        protected void Awake()
        {
            this.m_Toggle = this.gameObject.GetComponent<Toggle>();
        }

        protected void OnEnable()
        {
            this.m_Toggle.onValueChanged.AddListener(OnToggleValueChanged);
        }

        protected void OnDisable()
        {
            this.m_Toggle.onValueChanged.RemoveListener(OnToggleValueChanged);
        }

        protected void OnToggleValueChanged(bool value)
        {
            if (this.m_TargetInfo != null)
            {
                if (value)
                {
                    this.m_TargetInfo.Activate();
                }
                else
                {
                    this.m_TargetInfo.Deactivate();
                }
            }
        }
    }
}
