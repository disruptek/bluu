
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2018-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Storage subsystem operation endpoints and objects.
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
  macServiceName = "azsadmin-StorageSubSystem"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageSubSystemsList_593646 = ref object of OpenApiRestCall_593424
proc url_StorageSubSystemsList_593648(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnit" in path, "`scaleUnit` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnits/"),
               (kind: VariableSegment, value: "scaleUnit"),
               (kind: ConstantSegment, value: "/storageSubSystems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSubSystemsList_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of all storage subsystems for a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: JString (required)
  ##            : Name of the scale units.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593822 = path.getOrDefault("resourceGroupName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "resourceGroupName", valid_593822
  var valid_593823 = path.getOrDefault("scaleUnit")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "scaleUnit", valid_593823
  var valid_593824 = path.getOrDefault("subscriptionId")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "subscriptionId", valid_593824
  var valid_593825 = path.getOrDefault("location")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "location", valid_593825
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593839 = query.getOrDefault("api-version")
  valid_593839 = validateParameter(valid_593839, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593839 != nil:
    section.add "api-version", valid_593839
  var valid_593840 = query.getOrDefault("$filter")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "$filter", valid_593840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593863: Call_StorageSubSystemsList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all storage subsystems for a location.
  ## 
  let valid = call_593863.validator(path, query, header, formData, body)
  let scheme = call_593863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593863.url(scheme.get, call_593863.host, call_593863.base,
                         call_593863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593863, url, valid)

proc call*(call_593934: Call_StorageSubSystemsList_593646;
          resourceGroupName: string; scaleUnit: string; subscriptionId: string;
          location: string; apiVersion: string = "2018-10-01"; Filter: string = ""): Recallable =
  ## storageSubSystemsList
  ## Returns a list of all storage subsystems for a location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: string (required)
  ##            : Name of the scale units.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_593935 = newJObject()
  var query_593937 = newJObject()
  add(path_593935, "resourceGroupName", newJString(resourceGroupName))
  add(path_593935, "scaleUnit", newJString(scaleUnit))
  add(query_593937, "api-version", newJString(apiVersion))
  add(path_593935, "subscriptionId", newJString(subscriptionId))
  add(path_593935, "location", newJString(location))
  add(query_593937, "$filter", newJString(Filter))
  result = call_593934.call(path_593935, query_593937, nil, nil, nil)

var storageSubSystemsList* = Call_StorageSubSystemsList_593646(
    name: "storageSubSystemsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits/{scaleUnit}/storageSubSystems",
    validator: validate_StorageSubSystemsList_593647, base: "",
    url: url_StorageSubSystemsList_593648, schemes: {Scheme.Https})
type
  Call_StorageSubSystemsGet_593976 = ref object of OpenApiRestCall_593424
proc url_StorageSubSystemsGet_593978(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "scaleUnit" in path, "`scaleUnit` is a required path parameter"
  assert "storageSubSystem" in path,
        "`storageSubSystem` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/scaleUnits/"),
               (kind: VariableSegment, value: "scaleUnit"),
               (kind: ConstantSegment, value: "/storageSubSystems/"),
               (kind: VariableSegment, value: "storageSubSystem")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageSubSystemsGet_593977(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return the requested storage subsystem.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: JString (required)
  ##            : Name of the scale units.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   storageSubSystem: JString (required)
  ##                   : Name of the storage system.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593979 = path.getOrDefault("resourceGroupName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "resourceGroupName", valid_593979
  var valid_593980 = path.getOrDefault("scaleUnit")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "scaleUnit", valid_593980
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  var valid_593982 = path.getOrDefault("storageSubSystem")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "storageSubSystem", valid_593982
  var valid_593983 = path.getOrDefault("location")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "location", valid_593983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593984 = query.getOrDefault("api-version")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = newJString("2018-10-01"))
  if valid_593984 != nil:
    section.add "api-version", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_StorageSubSystemsGet_593976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the requested storage subsystem.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_StorageSubSystemsGet_593976;
          resourceGroupName: string; scaleUnit: string; subscriptionId: string;
          storageSubSystem: string; location: string;
          apiVersion: string = "2018-10-01"): Recallable =
  ## storageSubSystemsGet
  ## Return the requested storage subsystem.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   scaleUnit: string (required)
  ##            : Name of the scale units.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   storageSubSystem: string (required)
  ##                   : Name of the storage system.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(path_593987, "resourceGroupName", newJString(resourceGroupName))
  add(path_593987, "scaleUnit", newJString(scaleUnit))
  add(query_593988, "api-version", newJString(apiVersion))
  add(path_593987, "subscriptionId", newJString(subscriptionId))
  add(path_593987, "storageSubSystem", newJString(storageSubSystem))
  add(path_593987, "location", newJString(location))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var storageSubSystemsGet* = Call_StorageSubSystemsGet_593976(
    name: "storageSubSystemsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/scaleUnits/{scaleUnit}/storageSubSystems/{storageSubSystem}",
    validator: validate_StorageSubSystemsGet_593977, base: "",
    url: url_StorageSubSystemsGet_593978, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
