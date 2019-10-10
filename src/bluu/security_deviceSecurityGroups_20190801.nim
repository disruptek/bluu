
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2019-08-01
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "security-deviceSecurityGroups"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeviceSecurityGroupsList_573879 = ref object of OpenApiRestCall_573657
proc url_DeviceSecurityGroupsList_573881(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/deviceSecurityGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSecurityGroupsList_573880(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method get the list of device security groups for the specified IoT Hub resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_574041 = path.getOrDefault("resourceId")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "resourceId", valid_574041
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574042 = query.getOrDefault("api-version")
  valid_574042 = validateParameter(valid_574042, JString, required = true,
                                 default = nil)
  if valid_574042 != nil:
    section.add "api-version", valid_574042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574069: Call_DeviceSecurityGroupsList_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Use this method get the list of device security groups for the specified IoT Hub resource.
  ## 
  let valid = call_574069.validator(path, query, header, formData, body)
  let scheme = call_574069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574069.url(scheme.get, call_574069.host, call_574069.base,
                         call_574069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574069, url, valid)

proc call*(call_574140: Call_DeviceSecurityGroupsList_573879; apiVersion: string;
          resourceId: string): Recallable =
  ## deviceSecurityGroupsList
  ## Use this method get the list of device security groups for the specified IoT Hub resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  var path_574141 = newJObject()
  var query_574143 = newJObject()
  add(query_574143, "api-version", newJString(apiVersion))
  add(path_574141, "resourceId", newJString(resourceId))
  result = call_574140.call(path_574141, query_574143, nil, nil, nil)

var deviceSecurityGroupsList* = Call_DeviceSecurityGroupsList_573879(
    name: "deviceSecurityGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups",
    validator: validate_DeviceSecurityGroupsList_573880, base: "",
    url: url_DeviceSecurityGroupsList_573881, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsCreateOrUpdate_574201 = ref object of OpenApiRestCall_573657
proc url_DeviceSecurityGroupsCreateOrUpdate_574203(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "deviceSecurityGroupName" in path,
        "`deviceSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/deviceSecurityGroups/"),
               (kind: VariableSegment, value: "deviceSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSecurityGroupsCreateOrUpdate_574202(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method to creates or updates the device security group on a specified IoT Hub resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: JString (required)
  ##                          : The name of the device security group. Note that the name of the device security group is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_574204 = path.getOrDefault("resourceId")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "resourceId", valid_574204
  var valid_574205 = path.getOrDefault("deviceSecurityGroupName")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "deviceSecurityGroupName", valid_574205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574206 = query.getOrDefault("api-version")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "api-version", valid_574206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   deviceSecurityGroup: JObject (required)
  ##                      : Security group object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574208: Call_DeviceSecurityGroupsCreateOrUpdate_574201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Use this method to creates or updates the device security group on a specified IoT Hub resource.
  ## 
  let valid = call_574208.validator(path, query, header, formData, body)
  let scheme = call_574208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574208.url(scheme.get, call_574208.host, call_574208.base,
                         call_574208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574208, url, valid)

proc call*(call_574209: Call_DeviceSecurityGroupsCreateOrUpdate_574201;
          apiVersion: string; deviceSecurityGroup: JsonNode; resourceId: string;
          deviceSecurityGroupName: string): Recallable =
  ## deviceSecurityGroupsCreateOrUpdate
  ## Use this method to creates or updates the device security group on a specified IoT Hub resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   deviceSecurityGroup: JObject (required)
  ##                      : Security group object.
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the device security group. Note that the name of the device security group is case insensitive.
  var path_574210 = newJObject()
  var query_574211 = newJObject()
  var body_574212 = newJObject()
  add(query_574211, "api-version", newJString(apiVersion))
  if deviceSecurityGroup != nil:
    body_574212 = deviceSecurityGroup
  add(path_574210, "resourceId", newJString(resourceId))
  add(path_574210, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  result = call_574209.call(path_574210, query_574211, nil, nil, body_574212)

var deviceSecurityGroupsCreateOrUpdate* = Call_DeviceSecurityGroupsCreateOrUpdate_574201(
    name: "deviceSecurityGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsCreateOrUpdate_574202, base: "",
    url: url_DeviceSecurityGroupsCreateOrUpdate_574203, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsGet_574182 = ref object of OpenApiRestCall_573657
proc url_DeviceSecurityGroupsGet_574184(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "deviceSecurityGroupName" in path,
        "`deviceSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/deviceSecurityGroups/"),
               (kind: VariableSegment, value: "deviceSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSecurityGroupsGet_574183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Use this method to get the device security group for the specified IoT Hub resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: JString (required)
  ##                          : The name of the device security group. Note that the name of the device security group is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_574194 = path.getOrDefault("resourceId")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "resourceId", valid_574194
  var valid_574195 = path.getOrDefault("deviceSecurityGroupName")
  valid_574195 = validateParameter(valid_574195, JString, required = true,
                                 default = nil)
  if valid_574195 != nil:
    section.add "deviceSecurityGroupName", valid_574195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574196 = query.getOrDefault("api-version")
  valid_574196 = validateParameter(valid_574196, JString, required = true,
                                 default = nil)
  if valid_574196 != nil:
    section.add "api-version", valid_574196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574197: Call_DeviceSecurityGroupsGet_574182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Use this method to get the device security group for the specified IoT Hub resource.
  ## 
  let valid = call_574197.validator(path, query, header, formData, body)
  let scheme = call_574197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574197.url(scheme.get, call_574197.host, call_574197.base,
                         call_574197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574197, url, valid)

proc call*(call_574198: Call_DeviceSecurityGroupsGet_574182; apiVersion: string;
          resourceId: string; deviceSecurityGroupName: string): Recallable =
  ## deviceSecurityGroupsGet
  ## Use this method to get the device security group for the specified IoT Hub resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the device security group. Note that the name of the device security group is case insensitive.
  var path_574199 = newJObject()
  var query_574200 = newJObject()
  add(query_574200, "api-version", newJString(apiVersion))
  add(path_574199, "resourceId", newJString(resourceId))
  add(path_574199, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  result = call_574198.call(path_574199, query_574200, nil, nil, nil)

var deviceSecurityGroupsGet* = Call_DeviceSecurityGroupsGet_574182(
    name: "deviceSecurityGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsGet_574183, base: "",
    url: url_DeviceSecurityGroupsGet_574184, schemes: {Scheme.Https})
type
  Call_DeviceSecurityGroupsDelete_574213 = ref object of OpenApiRestCall_573657
proc url_DeviceSecurityGroupsDelete_574215(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "deviceSecurityGroupName" in path,
        "`deviceSecurityGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Security/deviceSecurityGroups/"),
               (kind: VariableSegment, value: "deviceSecurityGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeviceSecurityGroupsDelete_574214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## User this method to deletes the device security group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: JString (required)
  ##                          : The name of the device security group. Note that the name of the device security group is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_574216 = path.getOrDefault("resourceId")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "resourceId", valid_574216
  var valid_574217 = path.getOrDefault("deviceSecurityGroupName")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "deviceSecurityGroupName", valid_574217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574218 = query.getOrDefault("api-version")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "api-version", valid_574218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574219: Call_DeviceSecurityGroupsDelete_574213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## User this method to deletes the device security group.
  ## 
  let valid = call_574219.validator(path, query, header, formData, body)
  let scheme = call_574219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574219.url(scheme.get, call_574219.host, call_574219.base,
                         call_574219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574219, url, valid)

proc call*(call_574220: Call_DeviceSecurityGroupsDelete_574213; apiVersion: string;
          resourceId: string; deviceSecurityGroupName: string): Recallable =
  ## deviceSecurityGroupsDelete
  ## User this method to deletes the device security group.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceId: string (required)
  ##             : The identifier of the resource.
  ##   deviceSecurityGroupName: string (required)
  ##                          : The name of the device security group. Note that the name of the device security group is case insensitive.
  var path_574221 = newJObject()
  var query_574222 = newJObject()
  add(query_574222, "api-version", newJString(apiVersion))
  add(path_574221, "resourceId", newJString(resourceId))
  add(path_574221, "deviceSecurityGroupName", newJString(deviceSecurityGroupName))
  result = call_574220.call(path_574221, query_574222, nil, nil, nil)

var deviceSecurityGroupsDelete* = Call_DeviceSecurityGroupsDelete_574213(
    name: "deviceSecurityGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.Security/deviceSecurityGroups/{deviceSecurityGroupName}",
    validator: validate_DeviceSecurityGroupsDelete_574214, base: "",
    url: url_DeviceSecurityGroupsDelete_574215, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
