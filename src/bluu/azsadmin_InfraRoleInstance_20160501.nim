
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Infrastructure role instance operation endpoints and objects.
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
  macServiceName = "azsadmin-InfraRoleInstance"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_InfraRoleInstancesList_574679 = ref object of OpenApiRestCall_574457
proc url_InfraRoleInstancesList_574681(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infraRoleInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InfraRoleInstancesList_574680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of all infrastructure role instances at a location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  var valid_574844 = path.getOrDefault("location")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "location", valid_574844
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574858 = query.getOrDefault("api-version")
  valid_574858 = validateParameter(valid_574858, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574858 != nil:
    section.add "api-version", valid_574858
  var valid_574859 = query.getOrDefault("$filter")
  valid_574859 = validateParameter(valid_574859, JString, required = false,
                                 default = nil)
  if valid_574859 != nil:
    section.add "$filter", valid_574859
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574886: Call_InfraRoleInstancesList_574679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all infrastructure role instances at a location.
  ## 
  let valid = call_574886.validator(path, query, header, formData, body)
  let scheme = call_574886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574886.url(scheme.get, call_574886.host, call_574886.base,
                         call_574886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574886, url, valid)

proc call*(call_574957: Call_InfraRoleInstancesList_574679;
          resourceGroupName: string; subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## infraRoleInstancesList
  ## Returns a list of all infrastructure role instances at a location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574958 = newJObject()
  var query_574960 = newJObject()
  add(path_574958, "resourceGroupName", newJString(resourceGroupName))
  add(query_574960, "api-version", newJString(apiVersion))
  add(path_574958, "subscriptionId", newJString(subscriptionId))
  add(path_574958, "location", newJString(location))
  add(query_574960, "$filter", newJString(Filter))
  result = call_574957.call(path_574958, query_574960, nil, nil, nil)

var infraRoleInstancesList* = Call_InfraRoleInstancesList_574679(
    name: "infraRoleInstancesList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/infraRoleInstances",
    validator: validate_InfraRoleInstancesList_574680, base: "",
    url: url_InfraRoleInstancesList_574681, schemes: {Scheme.Https})
type
  Call_InfraRoleInstancesGet_574999 = ref object of OpenApiRestCall_574457
proc url_InfraRoleInstancesGet_575001(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "infraRoleInstance" in path,
        "`infraRoleInstance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infraRoleInstances/"),
               (kind: VariableSegment, value: "infraRoleInstance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InfraRoleInstancesGet_575000(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Return the requested infrastructure role instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: JString (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575011 = path.getOrDefault("resourceGroupName")
  valid_575011 = validateParameter(valid_575011, JString, required = true,
                                 default = nil)
  if valid_575011 != nil:
    section.add "resourceGroupName", valid_575011
  var valid_575012 = path.getOrDefault("subscriptionId")
  valid_575012 = validateParameter(valid_575012, JString, required = true,
                                 default = nil)
  if valid_575012 != nil:
    section.add "subscriptionId", valid_575012
  var valid_575013 = path.getOrDefault("infraRoleInstance")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "infraRoleInstance", valid_575013
  var valid_575014 = path.getOrDefault("location")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "location", valid_575014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575015 = query.getOrDefault("api-version")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575015 != nil:
    section.add "api-version", valid_575015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575016: Call_InfraRoleInstancesGet_574999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Return the requested infrastructure role instance.
  ## 
  let valid = call_575016.validator(path, query, header, formData, body)
  let scheme = call_575016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575016.url(scheme.get, call_575016.host, call_575016.base,
                         call_575016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575016, url, valid)

proc call*(call_575017: Call_InfraRoleInstancesGet_574999;
          resourceGroupName: string; subscriptionId: string;
          infraRoleInstance: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## infraRoleInstancesGet
  ## Return the requested infrastructure role instance.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: string (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575018 = newJObject()
  var query_575019 = newJObject()
  add(path_575018, "resourceGroupName", newJString(resourceGroupName))
  add(query_575019, "api-version", newJString(apiVersion))
  add(path_575018, "subscriptionId", newJString(subscriptionId))
  add(path_575018, "infraRoleInstance", newJString(infraRoleInstance))
  add(path_575018, "location", newJString(location))
  result = call_575017.call(path_575018, query_575019, nil, nil, nil)

var infraRoleInstancesGet* = Call_InfraRoleInstancesGet_574999(
    name: "infraRoleInstancesGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/infraRoleInstances/{infraRoleInstance}",
    validator: validate_InfraRoleInstancesGet_575000, base: "",
    url: url_InfraRoleInstancesGet_575001, schemes: {Scheme.Https})
type
  Call_InfraRoleInstancesPowerOff_575020 = ref object of OpenApiRestCall_574457
proc url_InfraRoleInstancesPowerOff_575022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "infraRoleInstance" in path,
        "`infraRoleInstance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infraRoleInstances/"),
               (kind: VariableSegment, value: "infraRoleInstance"),
               (kind: ConstantSegment, value: "/PowerOff")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InfraRoleInstancesPowerOff_575021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power off an infrastructure role instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: JString (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575023 = path.getOrDefault("resourceGroupName")
  valid_575023 = validateParameter(valid_575023, JString, required = true,
                                 default = nil)
  if valid_575023 != nil:
    section.add "resourceGroupName", valid_575023
  var valid_575024 = path.getOrDefault("subscriptionId")
  valid_575024 = validateParameter(valid_575024, JString, required = true,
                                 default = nil)
  if valid_575024 != nil:
    section.add "subscriptionId", valid_575024
  var valid_575025 = path.getOrDefault("infraRoleInstance")
  valid_575025 = validateParameter(valid_575025, JString, required = true,
                                 default = nil)
  if valid_575025 != nil:
    section.add "infraRoleInstance", valid_575025
  var valid_575026 = path.getOrDefault("location")
  valid_575026 = validateParameter(valid_575026, JString, required = true,
                                 default = nil)
  if valid_575026 != nil:
    section.add "location", valid_575026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575027 = query.getOrDefault("api-version")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575027 != nil:
    section.add "api-version", valid_575027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575028: Call_InfraRoleInstancesPowerOff_575020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power off an infrastructure role instance.
  ## 
  let valid = call_575028.validator(path, query, header, formData, body)
  let scheme = call_575028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575028.url(scheme.get, call_575028.host, call_575028.base,
                         call_575028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575028, url, valid)

proc call*(call_575029: Call_InfraRoleInstancesPowerOff_575020;
          resourceGroupName: string; subscriptionId: string;
          infraRoleInstance: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## infraRoleInstancesPowerOff
  ## Power off an infrastructure role instance.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: string (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575030 = newJObject()
  var query_575031 = newJObject()
  add(path_575030, "resourceGroupName", newJString(resourceGroupName))
  add(query_575031, "api-version", newJString(apiVersion))
  add(path_575030, "subscriptionId", newJString(subscriptionId))
  add(path_575030, "infraRoleInstance", newJString(infraRoleInstance))
  add(path_575030, "location", newJString(location))
  result = call_575029.call(path_575030, query_575031, nil, nil, nil)

var infraRoleInstancesPowerOff* = Call_InfraRoleInstancesPowerOff_575020(
    name: "infraRoleInstancesPowerOff", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/infraRoleInstances/{infraRoleInstance}/PowerOff",
    validator: validate_InfraRoleInstancesPowerOff_575021, base: "",
    url: url_InfraRoleInstancesPowerOff_575022, schemes: {Scheme.Https})
type
  Call_InfraRoleInstancesPowerOn_575032 = ref object of OpenApiRestCall_574457
proc url_InfraRoleInstancesPowerOn_575034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "infraRoleInstance" in path,
        "`infraRoleInstance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infraRoleInstances/"),
               (kind: VariableSegment, value: "infraRoleInstance"),
               (kind: ConstantSegment, value: "/PowerOn")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InfraRoleInstancesPowerOn_575033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power on an infrastructure role instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: JString (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575035 = path.getOrDefault("resourceGroupName")
  valid_575035 = validateParameter(valid_575035, JString, required = true,
                                 default = nil)
  if valid_575035 != nil:
    section.add "resourceGroupName", valid_575035
  var valid_575036 = path.getOrDefault("subscriptionId")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "subscriptionId", valid_575036
  var valid_575037 = path.getOrDefault("infraRoleInstance")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "infraRoleInstance", valid_575037
  var valid_575038 = path.getOrDefault("location")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "location", valid_575038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575039 = query.getOrDefault("api-version")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575039 != nil:
    section.add "api-version", valid_575039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575040: Call_InfraRoleInstancesPowerOn_575032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Power on an infrastructure role instance.
  ## 
  let valid = call_575040.validator(path, query, header, formData, body)
  let scheme = call_575040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575040.url(scheme.get, call_575040.host, call_575040.base,
                         call_575040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575040, url, valid)

proc call*(call_575041: Call_InfraRoleInstancesPowerOn_575032;
          resourceGroupName: string; subscriptionId: string;
          infraRoleInstance: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## infraRoleInstancesPowerOn
  ## Power on an infrastructure role instance.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: string (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575042 = newJObject()
  var query_575043 = newJObject()
  add(path_575042, "resourceGroupName", newJString(resourceGroupName))
  add(query_575043, "api-version", newJString(apiVersion))
  add(path_575042, "subscriptionId", newJString(subscriptionId))
  add(path_575042, "infraRoleInstance", newJString(infraRoleInstance))
  add(path_575042, "location", newJString(location))
  result = call_575041.call(path_575042, query_575043, nil, nil, nil)

var infraRoleInstancesPowerOn* = Call_InfraRoleInstancesPowerOn_575032(
    name: "infraRoleInstancesPowerOn", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/infraRoleInstances/{infraRoleInstance}/PowerOn",
    validator: validate_InfraRoleInstancesPowerOn_575033, base: "",
    url: url_InfraRoleInstancesPowerOn_575034, schemes: {Scheme.Https})
type
  Call_InfraRoleInstancesReboot_575044 = ref object of OpenApiRestCall_574457
proc url_InfraRoleInstancesReboot_575046(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "infraRoleInstance" in path,
        "`infraRoleInstance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infraRoleInstances/"),
               (kind: VariableSegment, value: "infraRoleInstance"),
               (kind: ConstantSegment, value: "/Reboot")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InfraRoleInstancesReboot_575045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reboot an infrastructure role instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: JString (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575047 = path.getOrDefault("resourceGroupName")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "resourceGroupName", valid_575047
  var valid_575048 = path.getOrDefault("subscriptionId")
  valid_575048 = validateParameter(valid_575048, JString, required = true,
                                 default = nil)
  if valid_575048 != nil:
    section.add "subscriptionId", valid_575048
  var valid_575049 = path.getOrDefault("infraRoleInstance")
  valid_575049 = validateParameter(valid_575049, JString, required = true,
                                 default = nil)
  if valid_575049 != nil:
    section.add "infraRoleInstance", valid_575049
  var valid_575050 = path.getOrDefault("location")
  valid_575050 = validateParameter(valid_575050, JString, required = true,
                                 default = nil)
  if valid_575050 != nil:
    section.add "location", valid_575050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575051 = query.getOrDefault("api-version")
  valid_575051 = validateParameter(valid_575051, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575051 != nil:
    section.add "api-version", valid_575051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575052: Call_InfraRoleInstancesReboot_575044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reboot an infrastructure role instance.
  ## 
  let valid = call_575052.validator(path, query, header, formData, body)
  let scheme = call_575052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575052.url(scheme.get, call_575052.host, call_575052.base,
                         call_575052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575052, url, valid)

proc call*(call_575053: Call_InfraRoleInstancesReboot_575044;
          resourceGroupName: string; subscriptionId: string;
          infraRoleInstance: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## infraRoleInstancesReboot
  ## Reboot an infrastructure role instance.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: string (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575054 = newJObject()
  var query_575055 = newJObject()
  add(path_575054, "resourceGroupName", newJString(resourceGroupName))
  add(query_575055, "api-version", newJString(apiVersion))
  add(path_575054, "subscriptionId", newJString(subscriptionId))
  add(path_575054, "infraRoleInstance", newJString(infraRoleInstance))
  add(path_575054, "location", newJString(location))
  result = call_575053.call(path_575054, query_575055, nil, nil, nil)

var infraRoleInstancesReboot* = Call_InfraRoleInstancesReboot_575044(
    name: "infraRoleInstancesReboot", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/infraRoleInstances/{infraRoleInstance}/Reboot",
    validator: validate_InfraRoleInstancesReboot_575045, base: "",
    url: url_InfraRoleInstancesReboot_575046, schemes: {Scheme.Https})
type
  Call_InfraRoleInstancesShutdown_575056 = ref object of OpenApiRestCall_574457
proc url_InfraRoleInstancesShutdown_575058(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "infraRoleInstance" in path,
        "`infraRoleInstance` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/infraRoleInstances/"),
               (kind: VariableSegment, value: "infraRoleInstance"),
               (kind: ConstantSegment, value: "/Shutdown")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InfraRoleInstancesShutdown_575057(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shut down an infrastructure role instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: JString (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575059 = path.getOrDefault("resourceGroupName")
  valid_575059 = validateParameter(valid_575059, JString, required = true,
                                 default = nil)
  if valid_575059 != nil:
    section.add "resourceGroupName", valid_575059
  var valid_575060 = path.getOrDefault("subscriptionId")
  valid_575060 = validateParameter(valid_575060, JString, required = true,
                                 default = nil)
  if valid_575060 != nil:
    section.add "subscriptionId", valid_575060
  var valid_575061 = path.getOrDefault("infraRoleInstance")
  valid_575061 = validateParameter(valid_575061, JString, required = true,
                                 default = nil)
  if valid_575061 != nil:
    section.add "infraRoleInstance", valid_575061
  var valid_575062 = path.getOrDefault("location")
  valid_575062 = validateParameter(valid_575062, JString, required = true,
                                 default = nil)
  if valid_575062 != nil:
    section.add "location", valid_575062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575063 = query.getOrDefault("api-version")
  valid_575063 = validateParameter(valid_575063, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575063 != nil:
    section.add "api-version", valid_575063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575064: Call_InfraRoleInstancesShutdown_575056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shut down an infrastructure role instance.
  ## 
  let valid = call_575064.validator(path, query, header, formData, body)
  let scheme = call_575064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575064.url(scheme.get, call_575064.host, call_575064.base,
                         call_575064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575064, url, valid)

proc call*(call_575065: Call_InfraRoleInstancesShutdown_575056;
          resourceGroupName: string; subscriptionId: string;
          infraRoleInstance: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## infraRoleInstancesShutdown
  ## Shut down an infrastructure role instance.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   infraRoleInstance: string (required)
  ##                    : Name of an infrastructure role instance.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575066 = newJObject()
  var query_575067 = newJObject()
  add(path_575066, "resourceGroupName", newJString(resourceGroupName))
  add(query_575067, "api-version", newJString(apiVersion))
  add(path_575066, "subscriptionId", newJString(subscriptionId))
  add(path_575066, "infraRoleInstance", newJString(infraRoleInstance))
  add(path_575066, "location", newJString(location))
  result = call_575065.call(path_575066, query_575067, nil, nil, nil)

var infraRoleInstancesShutdown* = Call_InfraRoleInstancesShutdown_575056(
    name: "infraRoleInstancesShutdown", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/infraRoleInstances/{infraRoleInstance}/Shutdown",
    validator: validate_InfraRoleInstancesShutdown_575057, base: "",
    url: url_InfraRoleInstancesShutdown_575058, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
