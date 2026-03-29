"""
DJI机甲大师裁判系统通信协议ROS 2功能包安装配置

本文件为ament_cmake混合包的Python安装配置。
消息生成由CMakeLists.txt处理，Python模块由ament_python_install_package安装。
"""
from setuptools import find_packages, setup
import os
from glob import glob

package_name = 'dji_referee_protocol'

setup(
    name=package_name,
    version='1.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
         ['resource/' + package_name]),
        (os.path.join('share', package_name, 'launch'), glob('launch/*.py')),
        (os.path.join('share', package_name, 'config'), glob('config/*.yaml')),
        (os.path.join('share', package_name), ['package.xml']),
    ],
    install_requires=['setuptools', 'pyserial'],
    zip_safe=True,
    maintainer='Your Name',
    maintainer_email='your_email@example.com',
    description='DJI RoboMaster裁判系统通信协议ROS 2功能包',
    license='MIT',
    tests_require=['pytest'],
    # 注意：入口点由CMakeLists.txt中的install(PROGRAMS)处理
    # 这里不需要entry_points
)
