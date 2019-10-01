
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DevSpacesManagement
## version: 2019-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Dev Spaces REST API
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "devspaces"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567879 = ref object of OpenApiRestCall_567657
proc url_OperationsList_567881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the supported operations by the Microsoft.DevSpaces resource provider along with their description.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568040 = query.getOrDefault("api-version")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "api-version", valid_568040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568063: Call_OperationsList_567879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the supported operations by the Microsoft.DevSpaces resource provider along with their description.
  ## 
  let valid = call_568063.validator(path, query, header, formData, body)
  let scheme = call_568063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568063.url(scheme.get, call_568063.host, call_568063.base,
                         call_568063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568063, url, valid)

proc call*(call_568134: Call_OperationsList_567879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the supported operations by the Microsoft.DevSpaces resource provider along with their description.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DevSpaces/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_ControllersList_568175 = ref object of OpenApiRestCall_567657
proc url_ControllersList_568177(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevSpaces/controllers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ControllersList_568176(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Lists all the Azure Dev Spaces Controllers with their properties in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568192 = path.getOrDefault("subscriptionId")
  valid_568192 = validateParameter(valid_568192, JString, required = true,
                                 default = nil)
  if valid_568192 != nil:
    section.add "subscriptionId", valid_568192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568193 = query.getOrDefault("api-version")
  valid_568193 = validateParameter(valid_568193, JString, required = true,
                                 default = nil)
  if valid_568193 != nil:
    section.add "api-version", valid_568193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568194: Call_ControllersList_568175; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Azure Dev Spaces Controllers with their properties in the subscription.
  ## 
  let valid = call_568194.validator(path, query, header, formData, body)
  let scheme = call_568194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568194.url(scheme.get, call_568194.host, call_568194.base,
                         call_568194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568194, url, valid)

proc call*(call_568195: Call_ControllersList_568175; apiVersion: string;
          subscriptionId: string): Recallable =
  ## controllersList
  ## Lists all the Azure Dev Spaces Controllers with their properties in the subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568196 = newJObject()
  var query_568197 = newJObject()
  add(query_568197, "api-version", newJString(apiVersion))
  add(path_568196, "subscriptionId", newJString(subscriptionId))
  result = call_568195.call(path_568196, query_568197, nil, nil, nil)

var controllersList* = Call_ControllersList_568175(name: "controllersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevSpaces/controllers",
    validator: validate_ControllersList_568176, base: "", url: url_ControllersList_568177,
    schemes: {Scheme.Https})
type
  Call_ControllersListByResourceGroup_568198 = ref object of OpenApiRestCall_567657
proc url_ControllersListByResourceGroup_568200(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DevSpaces/controllers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ControllersListByResourceGroup_568199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Azure Dev Spaces Controllers with their properties in the specified resource group and subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568201 = path.getOrDefault("resourceGroupName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "resourceGroupName", valid_568201
  var valid_568202 = path.getOrDefault("subscriptionId")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "subscriptionId", valid_568202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_ControllersListByResourceGroup_568198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Azure Dev Spaces Controllers with their properties in the specified resource group and subscription.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_ControllersListByResourceGroup_568198;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## controllersListByResourceGroup
  ## Lists all the Azure Dev Spaces Controllers with their properties in the specified resource group and subscription.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(path_568206, "resourceGroupName", newJString(resourceGroupName))
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var controllersListByResourceGroup* = Call_ControllersListByResourceGroup_568198(
    name: "controllersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers",
    validator: validate_ControllersListByResourceGroup_568199, base: "",
    url: url_ControllersListByResourceGroup_568200, schemes: {Scheme.Https})
type
  Call_ControllersCreate_568219 = ref object of OpenApiRestCall_567657
proc url_ControllersCreate_568221(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DevSpaces/controllers/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ControllersCreate_568220(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an Azure Dev Spaces Controller with the specified create parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568239 = path.getOrDefault("resourceGroupName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "resourceGroupName", valid_568239
  var valid_568240 = path.getOrDefault("name")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "name", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568242 = query.getOrDefault("api-version")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "api-version", valid_568242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   controller: JObject (required)
  ##             : Controller create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_ControllersCreate_568219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Azure Dev Spaces Controller with the specified create parameters.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_ControllersCreate_568219; resourceGroupName: string;
          apiVersion: string; name: string; controller: JsonNode;
          subscriptionId: string): Recallable =
  ## controllersCreate
  ## Creates an Azure Dev Spaces Controller with the specified create parameters.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   controller: JObject (required)
  ##             : Controller create parameters.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  var body_568248 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "name", newJString(name))
  if controller != nil:
    body_568248 = controller
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  result = call_568245.call(path_568246, query_568247, nil, nil, body_568248)

var controllersCreate* = Call_ControllersCreate_568219(name: "controllersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}",
    validator: validate_ControllersCreate_568220, base: "",
    url: url_ControllersCreate_568221, schemes: {Scheme.Https})
type
  Call_ControllersGet_568208 = ref object of OpenApiRestCall_567657
proc url_ControllersGet_568210(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DevSpaces/controllers/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ControllersGet_568209(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the properties for an Azure Dev Spaces Controller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568211 = path.getOrDefault("resourceGroupName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceGroupName", valid_568211
  var valid_568212 = path.getOrDefault("name")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "name", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_ControllersGet_568208; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties for an Azure Dev Spaces Controller.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_ControllersGet_568208; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string): Recallable =
  ## controllersGet
  ## Gets the properties for an Azure Dev Spaces Controller.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(path_568217, "resourceGroupName", newJString(resourceGroupName))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "name", newJString(name))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var controllersGet* = Call_ControllersGet_568208(name: "controllersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}",
    validator: validate_ControllersGet_568209, base: "", url: url_ControllersGet_568210,
    schemes: {Scheme.Https})
type
  Call_ControllersUpdate_568260 = ref object of OpenApiRestCall_567657
proc url_ControllersUpdate_568262(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DevSpaces/controllers/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ControllersUpdate_568261(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the properties of an existing Azure Dev Spaces Controller with the specified update parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568263 = path.getOrDefault("resourceGroupName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "resourceGroupName", valid_568263
  var valid_568264 = path.getOrDefault("name")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "name", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   controllerUpdateParameters: JObject (required)
  ##                             : Parameters for updating the Azure Dev Spaces Controller.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_ControllersUpdate_568260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing Azure Dev Spaces Controller with the specified update parameters.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_ControllersUpdate_568260; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string;
          controllerUpdateParameters: JsonNode): Recallable =
  ## controllersUpdate
  ## Updates the properties of an existing Azure Dev Spaces Controller with the specified update parameters.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   controllerUpdateParameters: JObject (required)
  ##                             : Parameters for updating the Azure Dev Spaces Controller.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  var body_568272 = newJObject()
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "name", newJString(name))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  if controllerUpdateParameters != nil:
    body_568272 = controllerUpdateParameters
  result = call_568269.call(path_568270, query_568271, nil, nil, body_568272)

var controllersUpdate* = Call_ControllersUpdate_568260(name: "controllersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}",
    validator: validate_ControllersUpdate_568261, base: "",
    url: url_ControllersUpdate_568262, schemes: {Scheme.Https})
type
  Call_ControllersDelete_568249 = ref object of OpenApiRestCall_567657
proc url_ControllersDelete_568251(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DevSpaces/controllers/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ControllersDelete_568250(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an existing Azure Dev Spaces Controller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("name")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "name", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568255 = query.getOrDefault("api-version")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "api-version", valid_568255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568256: Call_ControllersDelete_568249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Dev Spaces Controller.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_ControllersDelete_568249; resourceGroupName: string;
          apiVersion: string; name: string; subscriptionId: string): Recallable =
  ## controllersDelete
  ## Deletes an existing Azure Dev Spaces Controller.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "name", newJString(name))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var controllersDelete* = Call_ControllersDelete_568249(name: "controllersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}",
    validator: validate_ControllersDelete_568250, base: "",
    url: url_ControllersDelete_568251, schemes: {Scheme.Https})
type
  Call_ControllersListConnectionDetails_568273 = ref object of OpenApiRestCall_567657
proc url_ControllersListConnectionDetails_568275(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DevSpaces/controllers/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/listConnectionDetails")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ControllersListConnectionDetails_568274(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists connection details for the underlying container resources of an Azure Dev Spaces Controller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568276 = path.getOrDefault("resourceGroupName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "resourceGroupName", valid_568276
  var valid_568277 = path.getOrDefault("name")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "name", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568279 = query.getOrDefault("api-version")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "api-version", valid_568279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   listConnectionDetailsParameters: JObject (required)
  ##                                  : Parameters for listing connection details of Azure Dev Spaces Controller.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_ControllersListConnectionDetails_568273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists connection details for the underlying container resources of an Azure Dev Spaces Controller.
  ## 
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_ControllersListConnectionDetails_568273;
          resourceGroupName: string; apiVersion: string; name: string;
          subscriptionId: string; listConnectionDetailsParameters: JsonNode): Recallable =
  ## controllersListConnectionDetails
  ## Lists connection details for the underlying container resources of an Azure Dev Spaces Controller.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   listConnectionDetailsParameters: JObject (required)
  ##                                  : Parameters for listing connection details of Azure Dev Spaces Controller.
  var path_568283 = newJObject()
  var query_568284 = newJObject()
  var body_568285 = newJObject()
  add(path_568283, "resourceGroupName", newJString(resourceGroupName))
  add(query_568284, "api-version", newJString(apiVersion))
  add(path_568283, "name", newJString(name))
  add(path_568283, "subscriptionId", newJString(subscriptionId))
  if listConnectionDetailsParameters != nil:
    body_568285 = listConnectionDetailsParameters
  result = call_568282.call(path_568283, query_568284, nil, nil, body_568285)

var controllersListConnectionDetails* = Call_ControllersListConnectionDetails_568273(
    name: "controllersListConnectionDetails", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}/listConnectionDetails",
    validator: validate_ControllersListConnectionDetails_568274, base: "",
    url: url_ControllersListConnectionDetails_568275, schemes: {Scheme.Https})
type
  Call_ContainerHostMappingsGetContainerHostMapping_568286 = ref object of OpenApiRestCall_567657
proc url_ContainerHostMappingsGetContainerHostMapping_568288(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/Microsoft.DevSpaces/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkContainerHostMapping")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerHostMappingsGetContainerHostMapping_568287(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   location: JString (required)
  ##           : Location of the container host.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568289 = path.getOrDefault("resourceGroupName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "resourceGroupName", valid_568289
  var valid_568290 = path.getOrDefault("subscriptionId")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "subscriptionId", valid_568290
  var valid_568291 = path.getOrDefault("location")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "location", valid_568291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568292 = query.getOrDefault("api-version")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "api-version", valid_568292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   containerHostMapping: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568294: Call_ContainerHostMappingsGetContainerHostMapping_568286;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_568294.validator(path, query, header, formData, body)
  let scheme = call_568294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568294.url(scheme.get, call_568294.host, call_568294.base,
                         call_568294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568294, url, valid)

proc call*(call_568295: Call_ContainerHostMappingsGetContainerHostMapping_568286;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          containerHostMapping: JsonNode; location: string): Recallable =
  ## containerHostMappingsGetContainerHostMapping
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   containerHostMapping: JObject (required)
  ##   location: string (required)
  ##           : Location of the container host.
  var path_568296 = newJObject()
  var query_568297 = newJObject()
  var body_568298 = newJObject()
  add(path_568296, "resourceGroupName", newJString(resourceGroupName))
  add(query_568297, "api-version", newJString(apiVersion))
  add(path_568296, "subscriptionId", newJString(subscriptionId))
  if containerHostMapping != nil:
    body_568298 = containerHostMapping
  add(path_568296, "location", newJString(location))
  result = call_568295.call(path_568296, query_568297, nil, nil, body_568298)

var containerHostMappingsGetContainerHostMapping* = Call_ContainerHostMappingsGetContainerHostMapping_568286(
    name: "containerHostMappingsGetContainerHostMapping",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/locations/{location}/checkContainerHostMapping",
    validator: validate_ContainerHostMappingsGetContainerHostMapping_568287,
    base: "", url: url_ContainerHostMappingsGetContainerHostMapping_568288,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
