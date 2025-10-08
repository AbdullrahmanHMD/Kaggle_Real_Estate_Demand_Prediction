from typing import Any, Union
import numpy as np
import torch


class BaseAdapter():
    def predict(self, X : Any):
        return NotImplementedError


class SklearnModelAdapter(BaseAdapter):

    def __init__(self, model):
        self.model = model

    def predict(self, X : np.ndarray):
        self.model.predict(X)


class PytorchModelAdapter(BaseAdapter):
    def __init__(self, model : torch.Module, device='cpu'):
        self.model = model.to(device)
        self.device = device
        self.model.eval()


    def predict(self, X : Union[np.ndarray, torch.Tensor]):
        if isinstance(X, np.ndarray):
            X = torch.from_numpy(X).float()
        X = X.to(self.device)

        with torch.no_grad():
            output = self.model(X)

        return output.cpu().detach().numpy()
