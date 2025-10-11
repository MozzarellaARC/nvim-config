import bpy
from pathlib import Path


class Test:
    bl_info = "The quick brown fox"
    test = 1

    scene = bpy.types.scene

    def require(self, context):
        if self.test < 0:
            print("Failed")

    def test2(self, context):
        if self.test > 1:
            print("The Quick Brown Fox")


class Boom:
    bl_info = "The End"
    test2 = 2

    scene = bpy.types.scene

    def require(self, context):
        pass
