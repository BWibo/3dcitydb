DELETE FROM objectclass;

-- Core Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (0, null, 'Undefined', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1, null, 'ObjectType', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (2, 1, 'FeatureType', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (3, 2, 'AbstractFeature', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (4, 3, 'Address', 0, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (5, 3, 'AbstractPointCloud', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (6, 3, 'AbstractFeatureWithLifespan', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (7, 6, 'AbstractCityObject', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (8, 7, 'AbstractSpace', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (9, 8, 'AbstractLogicalSpace', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (10, 8, 'AbstractPhysicalSpace', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (11, 10, 'AbstractUnoccupiedSpace', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (12, 10, 'AbstractOccupiedSpace', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (13, 7, 'AbstractSpaceBoundary', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (14, 13, 'AbstractThematicSurface', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (15, 14, 'ClosureSurface', 0, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (16, 6, 'AbstractDynamizer', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (17, 6, 'AbstractVersionTransition', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (18, 6, 'CityModel', 0, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (19, 6, 'AbstractVersion', 1, 0, 0);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (20, 6, 'AbstractAppearance', 1, 0, 0);

-- Dynamizer Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (100, 16, 'Dynamizer', 0, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (101, 3, 'AbstractTimeseries', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (102, 101, 'AbstractAtomicTimeseries', 1, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (103, 102, 'TabulatedFileTimeseries', 0, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (104, 102, 'StandardFileTimeseries', 0, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (105, 102, 'GenericTimeseries', 0, 0, 1);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (106, 101, 'CompositeTimeseries', 0, 0, 1);

-- Generics Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (200, 9, 'GenericLogicalSpace', 0, 1, 2);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (201, 12, 'GenericOccupiedSpace', 0, 1, 2);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (202, 11, 'GenericUnoccupiedSpace', 0, 1, 2);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (203, 14, 'GenericThematicSurface', 0, 1, 2);

-- LandUse Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (300, 14, 'LandUse', 0, 1, 3);

-- PointCloud Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (400, 5, 'PointCloud', 0, 0, 4);

-- Relief Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (500, 13, 'ReliefFeature', 0, 1, 5);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (501, 13, 'AbstractReliefComponent', 1, 0, 5);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (502, 501, 'TINRelief', 0, 0, 5);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (503, 501, 'MassPointRelief', 0, 0, 5);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (504, 501, 'BreaklineRelief', 0, 0, 5);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (505, 501, 'RasterRelief', 0, 0, 5);

-- Transportation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (600, 11, 'AbstractTransportationSpace', 1, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (602, 600, 'Railway', 0, 1, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (603, 600, 'Section', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (604, 600, 'Waterway', 0, 1, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (605, 600, 'Intersection', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (606, 600, 'Square', 0, 1, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (607, 600, 'Track', 0, 1, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (608, 600, 'Road', 0, 1, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (609, 11, 'AuxiliaryTrafficSpace', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (610, 11, 'ClearanceSpace', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (611, 11, 'TrafficSpace', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (612, 11, 'Hole', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (613, 14, 'AuxiliaryTrafficArea', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (614, 14, 'TrafficArea', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (615, 14, 'Marking', 0, 0, 6);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (616, 14, 'HoleSurface', 0, 0, 6);

-- Construction Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (700, 12, 'AbstractConstruction', 1, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (701, 700, 'OtherConstruction', 0, 1, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (702, 12, 'AbstractConstructiveElement', 1, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (703, 12, 'AbstractFillingElement', 1, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (704, 703, 'Window', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (705, 703, 'Door', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (706, 12, 'AbstractFurniture', 1, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (707, 12, 'AbstractInstallation', 1, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (708, 14, 'AbstractConstructionSurface', 1, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (709, 708, 'WallSurface', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (710, 708, 'GroundSurface', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (711, 708, 'InteriorWallSurface', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (712, 708, 'RoofSurface', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (713, 708, 'FloorSurface', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (714, 708, 'OuterFloorSurface', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (715, 708, 'CeilingSurface', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (716, 708, 'OuterCeilingSurface', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (717, 14, 'AbstractFillingSurface', 1, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (718, 717, 'DoorSurface', 0, 0, 7);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (719, 717, 'WindowSurface', 0, 0, 7);

-- Tunnel Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (800, 700, 'AbstractTunnel', 1, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (801, 800, 'Tunnel', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (802, 800, 'TunnelPart', 0, 1, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (803, 702, 'TunnelConstructiveElement', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (804, 11, 'HollowSpace', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (805, 707, 'TunnelInstallation', 0, 0, 8);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (806, 706, 'TunnelFurniture', 0, 0, 8);

-- Building Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (900, 700, 'AbstractBuilding', 1, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (901, 900, 'Building', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (902, 900, 'BuildingPart', 0, 1, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (903, 702, 'BuildingConstructiveElement', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (904, 11, 'BuildingRoom', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (905, 707, 'BuildingInstallation', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (906, 706, 'BuildingFurniture', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (907, 9, 'AbstractBuildingSubdivision', 1, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (908, 907, 'BuildingUnit', 0, 0, 9);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (909, 907, 'Storey', 0, 0, 9);

-- Bridge Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1000, 700, 'AbstractBridge', 1, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1001, 1000, 'Bridge', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1002, 1000, 'BridgePart', 0, 1, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1003, 702, 'BridgeConstructiveElement', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1004, 11, 'BridgeRoom', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1005, 707, 'BridgeInstallation', 0, 0, 10);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1006, 706, 'BridgeFurniture', 0, 0, 10);

-- Appearance Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1100, 20, 'Appearance', 0, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1101, 3, 'AbstractSurfaceData', 1, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1102, 1101, 'X3DMaterial', 0, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1103, 1101, 'AbstractTexture', 1, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1104, 1103, 'ParameterizedTexture', 0, 0, 11);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1105, 1103, 'GeoreferencedTexture', 0, 0, 11);

-- CityObjectGroup Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1200, 9, 'CityObjectGroup', 0, 1, 12);

-- Vegetation Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1300, 12, 'AbstractVegetationObject', 1, 0, 13);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1301, 1300, 'SolitaryVegetationObject', 0, 1, 13);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1302, 1300, 'PlantCover', 0, 1, 13);

-- Versioning Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1400, 19, 'Version', 0, 0, 14);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1401, 17, 'VersionTransition', 0, 0, 14);

-- WaterBody Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1500, 12, 'WaterBody', 0, 1, 15);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1501, 14, 'AbstractWaterBoundarySurface', 1, 0, 15);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1502, 1501, 'WaterSurface', 0, 0, 15);

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1503, 1501, 'WaterGroundSurface', 0, 0, 15);

-- CityFurniture Module --

INSERT INTO objectclass (ID, SUPERCLASS_ID, CLASSNAME, IS_ABSTRACT, IS_TOPLEVEL, NAMESPACE_ID)
VALUES (1600, 12, 'CityFurniture', 0, 1, 16);











