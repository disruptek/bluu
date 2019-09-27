
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_VolumesList_593646 = ref object of OpenApiRestCall_593424
proc url_VolumesList_593648(protocol: Scheme; host: string; base: string;
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

proc validate_VolumesList_593647(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593809 = path.getOrDefault("resourceGroupName")
  valid_593809 = validateParameter(valid_593809, JString, required = true,
                                 default = nil)
  if valid_593809 != nil:
    section.add "resourceGroupName", valid_593809
  var valid_593810 = path.getOrDefault("subscriptionId")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "subscriptionId", valid_593810
  var valid_593811 = path.getOrDefault("storageSubSystem")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "storageSubSystem", valid_593811
  var valid_593812 = path.getOrDefault("storagePool")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "storagePool", valid_593812
  var valid_593813 = path.getOrDefault("location")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "location", valid_593813
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593827 = query.getOrDefault("api-version")
  valid_593827 = validateParameter(valid_593827, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593827 != nil:
    section.add "api-version", valid_593827
  var valid_593828 = query.getOrDefault("$filter")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "$filter", valid_593828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593855: Call_VolumesList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all storage volumes at a location.
  ## 
  let valid = call_593855.validator(path, query, header, formData, body)
  let scheme = call_593855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593855.url(scheme.get, call_593855.host, call_593855.base,
                         call_593855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593855, url, valid)

proc call*(call_593926: Call_VolumesList_593646; resourceGroupName: string;
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
  var path_593927 = newJObject()
  var query_593929 = newJObject()
  add(path_593927, "resourceGroupName", newJString(resourceGroupName))
  add(query_593929, "api-version", newJString(apiVersion))
  add(path_593927, "subscriptionId", newJString(subscriptionId))
  add(path_593927, "storageSubSystem", newJString(storageSubSystem))
  add(path_593927, "storagePool", newJString(storagePool))
  add(path_593927, "location", newJString(location))
  add(query_593929, "$filter", newJString(Filter))
  result = call_593926.call(path_593927, query_593929, nil, nil, nil)

var volumesList* = Call_VolumesList_593646(name: "volumesList",
                                        meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/storageSubSystems/{storageSubSystem}/storagePools/{storagePool}/volumes",
                                        validator: validate_VolumesList_593647,
                                        base: "", url: url_VolumesList_593648,
                                        schemes: {Scheme.Https})
type
  Call_VolumesGet_593968 = ref object of OpenApiRestCall_593424
proc url_VolumesGet_593970(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_VolumesGet_593969(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593980 = path.getOrDefault("resourceGroupName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "resourceGroupName", valid_593980
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  var valid_593982 = path.getOrDefault("volume")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "volume", valid_593982
  var valid_593983 = path.getOrDefault("storageSubSystem")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "storageSubSystem", valid_593983
  var valid_593984 = path.getOrDefault("storagePool")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "storagePool", valid_593984
  var valid_593985 = path.getOrDefault("location")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "location", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_VolumesGet_593968; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the requested a storage volume.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_VolumesGet_593968; resourceGroupName: string;
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
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(path_593989, "resourceGroupName", newJString(resourceGroupName))
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  add(path_593989, "volume", newJString(volume))
  add(path_593989, "storageSubSystem", newJString(storageSubSystem))
  add(path_593989, "storagePool", newJString(storagePool))
  add(path_593989, "location", newJString(location))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var volumesGet* = Call_VolumesGet_593968(name: "volumesGet",
                                      meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/storageSubSystems/{storageSubSystem}/storagePools/{storagePool}/volumes/{volume}",
                                      validator: validate_VolumesGet_593969,
                                      base: "", url: url_VolumesGet_593970,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
