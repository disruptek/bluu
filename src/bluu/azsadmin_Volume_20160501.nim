
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Volume operation endpoints and objects.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_574457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574457): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "azsadmin-Volume"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_VolumesList_574679 = ref object of OpenApiRestCall_574457
proc url_VolumesList_574681(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "storageSubSystem" in path,
        "`storageSubSystem` is a required path parameter"
  assert "storagePool" in path, "`storagePool` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/storageSubSystems/"),
               (kind: VariableSegment, value: "storageSubSystem"),
               (kind: ConstantSegment, value: "/storagePools/"),
               (kind: VariableSegment, value: "storagePool"),
               (kind: ConstantSegment, value: "/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesList_574680(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of all storage volumes at a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   storageSubSystem: JString (required)
  ##                   : Name of the storage system.
  ##   storagePool: JString (required)
  ##              : Storage pool name.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574842 = path.getOrDefault("resourceGroupName")
  valid_574842 = validateParameter(valid_574842, JString, required = true,
                                 default = nil)
  if valid_574842 != nil:
    section.add "resourceGroupName", valid_574842
  var valid_574843 = path.getOrDefault("subscriptionId")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "subscriptionId", valid_574843
  var valid_574844 = path.getOrDefault("storageSubSystem")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "storageSubSystem", valid_574844
  var valid_574845 = path.getOrDefault("storagePool")
  valid_574845 = validateParameter(valid_574845, JString, required = true,
                                 default = nil)
  if valid_574845 != nil:
    section.add "storagePool", valid_574845
  var valid_574846 = path.getOrDefault("location")
  valid_574846 = validateParameter(valid_574846, JString, required = true,
                                 default = nil)
  if valid_574846 != nil:
    section.add "location", valid_574846
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574860 = query.getOrDefault("api-version")
  valid_574860 = validateParameter(valid_574860, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574860 != nil:
    section.add "api-version", valid_574860
  var valid_574861 = query.getOrDefault("$filter")
  valid_574861 = validateParameter(valid_574861, JString, required = false,
                                 default = nil)
  if valid_574861 != nil:
    section.add "$filter", valid_574861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574888: Call_VolumesList_574679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all storage volumes at a location.
  ## 
  let valid = call_574888.validator(path, query, header, formData, body)
  let scheme = call_574888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574888.url(scheme.get, call_574888.host, call_574888.base,
                         call_574888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574888, url, valid)

proc call*(call_574959: Call_VolumesList_574679; resourceGroupName: string;
          subscriptionId: string; storageSubSystem: string; storagePool: string;
          location: string; apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## volumesList
  ## Returns a list of all storage volumes at a location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   storageSubSystem: string (required)
  ##                   : Name of the storage system.
  ##   storagePool: string (required)
  ##              : Storage pool name.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574960 = newJObject()
  var query_574962 = newJObject()
  add(path_574960, "resourceGroupName", newJString(resourceGroupName))
  add(query_574962, "api-version", newJString(apiVersion))
  add(path_574960, "subscriptionId", newJString(subscriptionId))
  add(path_574960, "storageSubSystem", newJString(storageSubSystem))
  add(path_574960, "storagePool", newJString(storagePool))
  add(path_574960, "location", newJString(location))
  add(query_574962, "$filter", newJString(Filter))
  result = call_574959.call(path_574960, query_574962, nil, nil, nil)

var volumesList* = Call_VolumesList_574679(name: "volumesList",
                                        meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/storageSubSystems/{storageSubSystem}/storagePools/{storagePool}/volumes",
                                        validator: validate_VolumesList_574680,
                                        base: "", url: url_VolumesList_574681,
                                        schemes: {Scheme.Https})
type
  Call_VolumesGet_575001 = ref object of OpenApiRestCall_574457
proc url_VolumesGet_575003(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "storageSubSystem" in path,
        "`storageSubSystem` is a required path parameter"
  assert "storagePool" in path, "`storagePool` is a required path parameter"
  assert "volume" in path, "`volume` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/storageSubSystems/"),
               (kind: VariableSegment, value: "storageSubSystem"),
               (kind: ConstantSegment, value: "/storagePools/"),
               (kind: VariableSegment, value: "storagePool"),
               (kind: ConstantSegment, value: "/volumes/"),
               (kind: VariableSegment, value: "volume")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumesGet_575002(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Return the requested a storage volume.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volume: JString (required)
  ##         : Name of the storage volume.
  ##   storageSubSystem: JString (required)
  ##                   : Name of the storage system.
  ##   storagePool: JString (required)
  ##              : Storage pool name.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575013 = path.getOrDefault("resourceGroupName")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "resourceGroupName", valid_575013
  var valid_575014 = path.getOrDefault("subscriptionId")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "subscriptionId", valid_575014
  var valid_575015 = path.getOrDefault("volume")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = nil)
  if valid_575015 != nil:
    section.add "volume", valid_575015
  var valid_575016 = path.getOrDefault("storageSubSystem")
  valid_575016 = validateParameter(valid_575016, JString, required = true,
                                 default = nil)
  if valid_575016 != nil:
    section.add "storageSubSystem", valid_575016
  var valid_575017 = path.getOrDefault("storagePool")
  valid_575017 = validateParameter(valid_575017, JString, required = true,
                                 default = nil)
  if valid_575017 != nil:
    section.add "storagePool", valid_575017
  var valid_575018 = path.getOrDefault("location")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "location", valid_575018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575019 = query.getOrDefault("api-version")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575019 != nil:
    section.add "api-version", valid_575019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575020: Call_VolumesGet_575001; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the requested a storage volume.
  ## 
  let valid = call_575020.validator(path, query, header, formData, body)
  let scheme = call_575020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575020.url(scheme.get, call_575020.host, call_575020.base,
                         call_575020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575020, url, valid)

proc call*(call_575021: Call_VolumesGet_575001; resourceGroupName: string;
          subscriptionId: string; volume: string; storageSubSystem: string;
          storagePool: string; location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## volumesGet
  ## Return the requested a storage volume.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   volume: string (required)
  ##         : Name of the storage volume.
  ##   storageSubSystem: string (required)
  ##                   : Name of the storage system.
  ##   storagePool: string (required)
  ##              : Storage pool name.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575022 = newJObject()
  var query_575023 = newJObject()
  add(path_575022, "resourceGroupName", newJString(resourceGroupName))
  add(query_575023, "api-version", newJString(apiVersion))
  add(path_575022, "subscriptionId", newJString(subscriptionId))
  add(path_575022, "volume", newJString(volume))
  add(path_575022, "storageSubSystem", newJString(storageSubSystem))
  add(path_575022, "storagePool", newJString(storagePool))
  add(path_575022, "location", newJString(location))
  result = call_575021.call(path_575022, query_575023, nil, nil, nil)

var volumesGet* = Call_VolumesGet_575001(name: "volumesGet",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/storageSubSystems/{storageSubSystem}/storagePools/{storagePool}/volumes/{volume}",
                                      validator: validate_VolumesGet_575002,
                                      base: "", url: url_VolumesGet_575003,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
