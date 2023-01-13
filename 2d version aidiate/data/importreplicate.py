import io
import os
import warnings
from PIL import Image
from stability_sdk import client
import stability_sdk.interfaces.gooseai.generation.generation_pb2 as generation
stability_api = client.StabilityInference(
    key='sk-nh6UyEdro7uHy31UINHkCeHuYVXCCag0OYKNuwtwOJ7iXHgq', 
    verbose=True,
)
with open("C:/Users/20212322/Downloads/test/sketch_221216d/sentence.txt", 'r') as file:
    data = file.read().rstrip()
answers = stability_api.generate(
    prompt=data,
    steps=120, # Amount of inference steps performed on image generation. Defaults to 30. 
    cfg_scale=3.0, # Influences how strongly your generation is guided to match your prompt.
                   # Setting this value higher increases the strength in which it tries to match your prompt.
                   # Defaults to 7.0 if not specified.
    width=512, # Generation width, defaults to 512 if not included.
    height=512, # Generation height, defaults to 512 if not included.
    samples=1, # Number of images to generate, defaults to 1 if not included.
    sampler=generation.SAMPLER_K_DPMPP_2M # Choose which sampler we want to denoise our generation with.
)
for resp in answers:
    for artifact in resp.artifacts:
        if artifact.finish_reason == generation.FILTER:
            warnings.warn(
                "Your request activated the API's safety filters and could not be processed."
                "Please modify the prompt and try again.")
        if artifact.type == generation.ARTIFACT_IMAGE:
            img = Image.open(io.BytesIO(artifact.binary))
            img.save("test.png")
            print(artifact.seed)