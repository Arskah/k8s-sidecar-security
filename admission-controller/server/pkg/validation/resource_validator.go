package validation

import (
  "github.com/sirupsen/logrus"
  corev1 "k8s.io/api/core/v1"
)

type resourceValidator struct {
  Logger logrus.FieldLogger
}

var _ podValidator = (*resourceValidator)(nil)

func (n resourceValidator) Name() string {
  return "resource_validator"
}

func EveryContainerHasResources(arr *[]corev1.Container) bool {
  for _, container := range *arr {
    if container.Resources.Limits == nil {
      return false
    }
  }
  return true
}

func (n resourceValidator) Validate(pod *corev1.Pod) (validation, error) {
  if (!EveryContainerHasResources(&pod.Spec.Containers)) {
    v := validation{
      Valid:  false,
      Reason: "all pod container do not have resources defined",
    }
    return v, nil
  }

  return validation{Valid: true, Reason: "resources defined"}, nil
}
