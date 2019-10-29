
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DevSpacesManagement
## version: 2018-06-01-preview
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "devspaces"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContainerHostMappingsGetContainerHostMapping_563777 = ref object of OpenApiRestCall_563555
proc url_ContainerHostMappingsGetContainerHostMapping_563779(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.DevSpaces/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkContainerHostMapping")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContainerHostMappingsGetContainerHostMapping_563778(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   location: JString (required)
  ##           : Location of the container host.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `location` field"
  var valid_563971 = path.getOrDefault("location")
  valid_563971 = validateParameter(valid_563971, JString, required = true,
                                 default = nil)
  if valid_563971 != nil:
    section.add "location", valid_563971
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563972 = query.getOrDefault("api-version")
  valid_563972 = validateParameter(valid_563972, JString, required = true,
                                 default = nil)
  if valid_563972 != nil:
    section.add "api-version", valid_563972
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

proc call*(call_563996: Call_ContainerHostMappingsGetContainerHostMapping_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_563996.validator(path, query, header, formData, body)
  let scheme = call_563996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563996.url(scheme.get, call_563996.host, call_563996.base,
                         call_563996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563996, url, valid)

proc call*(call_564067: Call_ContainerHostMappingsGetContainerHostMapping_563777;
          apiVersion: string; containerHostMapping: JsonNode; location: string): Recallable =
  ## containerHostMappingsGetContainerHostMapping
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   containerHostMapping: JObject (required)
  ##   location: string (required)
  ##           : Location of the container host.
  var path_564068 = newJObject()
  var query_564070 = newJObject()
  var body_564071 = newJObject()
  add(query_564070, "api-version", newJString(apiVersion))
  if containerHostMapping != nil:
    body_564071 = containerHostMapping
  add(path_564068, "location", newJString(location))
  result = call_564067.call(path_564068, query_564070, nil, nil, body_564071)

var containerHostMappingsGetContainerHostMapping* = Call_ContainerHostMappingsGetContainerHostMapping_563777(
    name: "containerHostMappingsGetContainerHostMapping",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/Microsoft.DevSpaces/locations/{location}/checkContainerHostMapping",
    validator: validate_ContainerHostMappingsGetContainerHostMapping_563778,
    base: "", url: url_ContainerHostMappingsGetContainerHostMapping_563779,
    schemes: {Scheme.Https})
type
  Call_OperationsList_564110 = ref object of OpenApiRestCall_563555
proc url_OperationsList_564112(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564111(path: JsonNode; query: JsonNode;
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
  var valid_564113 = query.getOrDefault("api-version")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "api-version", valid_564113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564114: Call_OperationsList_564110; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the supported operations by the Microsoft.DevSpaces resource provider along with their description.
  ## 
  let valid = call_564114.validator(path, query, header, formData, body)
  let scheme = call_564114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564114.url(scheme.get, call_564114.host, call_564114.base,
                         call_564114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564114, url, valid)

proc call*(call_564115: Call_OperationsList_564110; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the supported operations by the Microsoft.DevSpaces resource provider along with their description.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564116 = newJObject()
  add(query_564116, "api-version", newJString(apiVersion))
  result = call_564115.call(nil, query_564116, nil, nil, nil)

var operationsList* = Call_OperationsList_564110(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DevSpaces/operations",
    validator: validate_OperationsList_564111, base: "", url: url_OperationsList_564112,
    schemes: {Scheme.Https})
type
  Call_ControllersList_564117 = ref object of OpenApiRestCall_563555
proc url_ControllersList_564119(protocol: Scheme; host: string; base: string;
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

proc validate_ControllersList_564118(path: JsonNode; query: JsonNode;
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
  var valid_564120 = path.getOrDefault("subscriptionId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "subscriptionId", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564122: Call_ControllersList_564117; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Azure Dev Spaces Controllers with their properties in the subscription.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_ControllersList_564117; apiVersion: string;
          subscriptionId: string): Recallable =
  ## controllersList
  ## Lists all the Azure Dev Spaces Controllers with their properties in the subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "subscriptionId", newJString(subscriptionId))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var controllersList* = Call_ControllersList_564117(name: "controllersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DevSpaces/controllers",
    validator: validate_ControllersList_564118, base: "", url: url_ControllersList_564119,
    schemes: {Scheme.Https})
type
  Call_ControllersListByResourceGroup_564126 = ref object of OpenApiRestCall_563555
proc url_ControllersListByResourceGroup_564128(protocol: Scheme; host: string;
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

proc validate_ControllersListByResourceGroup_564127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the Azure Dev Spaces Controllers with their properties in the specified resource group and subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  var valid_564130 = path.getOrDefault("resourceGroupName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "resourceGroupName", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564132: Call_ControllersListByResourceGroup_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the Azure Dev Spaces Controllers with their properties in the specified resource group and subscription.
  ## 
  let valid = call_564132.validator(path, query, header, formData, body)
  let scheme = call_564132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564132.url(scheme.get, call_564132.host, call_564132.base,
                         call_564132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564132, url, valid)

proc call*(call_564133: Call_ControllersListByResourceGroup_564126;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## controllersListByResourceGroup
  ## Lists all the Azure Dev Spaces Controllers with their properties in the specified resource group and subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  var path_564134 = newJObject()
  var query_564135 = newJObject()
  add(query_564135, "api-version", newJString(apiVersion))
  add(path_564134, "subscriptionId", newJString(subscriptionId))
  add(path_564134, "resourceGroupName", newJString(resourceGroupName))
  result = call_564133.call(path_564134, query_564135, nil, nil, nil)

var controllersListByResourceGroup* = Call_ControllersListByResourceGroup_564126(
    name: "controllersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers",
    validator: validate_ControllersListByResourceGroup_564127, base: "",
    url: url_ControllersListByResourceGroup_564128, schemes: {Scheme.Https})
type
  Call_ControllersCreate_564147 = ref object of OpenApiRestCall_563555
proc url_ControllersCreate_564149(protocol: Scheme; host: string; base: string;
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

proc validate_ControllersCreate_564148(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an Azure Dev Spaces Controller with the specified create parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564150 = path.getOrDefault("name")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "name", valid_564150
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("resourceGroupName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "resourceGroupName", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
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

proc call*(call_564155: Call_ControllersCreate_564147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an Azure Dev Spaces Controller with the specified create parameters.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_ControllersCreate_564147; apiVersion: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          controller: JsonNode): Recallable =
  ## controllersCreate
  ## Creates an Azure Dev Spaces Controller with the specified create parameters.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  ##   controller: JObject (required)
  ##             : Controller create parameters.
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  var body_564159 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "name", newJString(name))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  if controller != nil:
    body_564159 = controller
  result = call_564156.call(path_564157, query_564158, nil, nil, body_564159)

var controllersCreate* = Call_ControllersCreate_564147(name: "controllersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}",
    validator: validate_ControllersCreate_564148, base: "",
    url: url_ControllersCreate_564149, schemes: {Scheme.Https})
type
  Call_ControllersGet_564136 = ref object of OpenApiRestCall_563555
proc url_ControllersGet_564138(protocol: Scheme; host: string; base: string;
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

proc validate_ControllersGet_564137(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the properties for an Azure Dev Spaces Controller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564139 = path.getOrDefault("name")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "name", valid_564139
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("resourceGroupName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "resourceGroupName", valid_564141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564142 = query.getOrDefault("api-version")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "api-version", valid_564142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564143: Call_ControllersGet_564136; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties for an Azure Dev Spaces Controller.
  ## 
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_ControllersGet_564136; apiVersion: string; name: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## controllersGet
  ## Gets the properties for an Azure Dev Spaces Controller.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  var path_564145 = newJObject()
  var query_564146 = newJObject()
  add(query_564146, "api-version", newJString(apiVersion))
  add(path_564145, "name", newJString(name))
  add(path_564145, "subscriptionId", newJString(subscriptionId))
  add(path_564145, "resourceGroupName", newJString(resourceGroupName))
  result = call_564144.call(path_564145, query_564146, nil, nil, nil)

var controllersGet* = Call_ControllersGet_564136(name: "controllersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}",
    validator: validate_ControllersGet_564137, base: "", url: url_ControllersGet_564138,
    schemes: {Scheme.Https})
type
  Call_ControllersUpdate_564171 = ref object of OpenApiRestCall_563555
proc url_ControllersUpdate_564173(protocol: Scheme; host: string; base: string;
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

proc validate_ControllersUpdate_564172(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Updates the properties of an existing Azure Dev Spaces Controller with the specified update parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564174 = path.getOrDefault("name")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "name", valid_564174
  var valid_564175 = path.getOrDefault("subscriptionId")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "subscriptionId", valid_564175
  var valid_564176 = path.getOrDefault("resourceGroupName")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "resourceGroupName", valid_564176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564177 = query.getOrDefault("api-version")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "api-version", valid_564177
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

proc call*(call_564179: Call_ControllersUpdate_564171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the properties of an existing Azure Dev Spaces Controller with the specified update parameters.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_ControllersUpdate_564171; apiVersion: string;
          name: string; subscriptionId: string; resourceGroupName: string;
          controllerUpdateParameters: JsonNode): Recallable =
  ## controllersUpdate
  ## Updates the properties of an existing Azure Dev Spaces Controller with the specified update parameters.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  ##   controllerUpdateParameters: JObject (required)
  ##                             : Parameters for updating the Azure Dev Spaces Controller.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  var body_564183 = newJObject()
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "name", newJString(name))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  if controllerUpdateParameters != nil:
    body_564183 = controllerUpdateParameters
  result = call_564180.call(path_564181, query_564182, nil, nil, body_564183)

var controllersUpdate* = Call_ControllersUpdate_564171(name: "controllersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}",
    validator: validate_ControllersUpdate_564172, base: "",
    url: url_ControllersUpdate_564173, schemes: {Scheme.Https})
type
  Call_ControllersDelete_564160 = ref object of OpenApiRestCall_563555
proc url_ControllersDelete_564162(protocol: Scheme; host: string; base: string;
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

proc validate_ControllersDelete_564161(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an existing Azure Dev Spaces Controller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564163 = path.getOrDefault("name")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "name", valid_564163
  var valid_564164 = path.getOrDefault("subscriptionId")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "subscriptionId", valid_564164
  var valid_564165 = path.getOrDefault("resourceGroupName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceGroupName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564167: Call_ControllersDelete_564160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Azure Dev Spaces Controller.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_ControllersDelete_564160; apiVersion: string;
          name: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## controllersDelete
  ## Deletes an existing Azure Dev Spaces Controller.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "name", newJString(name))
  add(path_564169, "subscriptionId", newJString(subscriptionId))
  add(path_564169, "resourceGroupName", newJString(resourceGroupName))
  result = call_564168.call(path_564169, query_564170, nil, nil, nil)

var controllersDelete* = Call_ControllersDelete_564160(name: "controllersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}",
    validator: validate_ControllersDelete_564161, base: "",
    url: url_ControllersDelete_564162, schemes: {Scheme.Https})
type
  Call_ControllersListConnectionDetails_564184 = ref object of OpenApiRestCall_563555
proc url_ControllersListConnectionDetails_564186(protocol: Scheme; host: string;
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

proc validate_ControllersListConnectionDetails_564185(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists connection details for the underlying container resources of an Azure Dev Spaces Controller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: JString (required)
  ##                    : Resource group to which the resource belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564187 = path.getOrDefault("name")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "name", valid_564187
  var valid_564188 = path.getOrDefault("subscriptionId")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "subscriptionId", valid_564188
  var valid_564189 = path.getOrDefault("resourceGroupName")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "resourceGroupName", valid_564189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564190 = query.getOrDefault("api-version")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "api-version", valid_564190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564191: Call_ControllersListConnectionDetails_564184;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists connection details for the underlying container resources of an Azure Dev Spaces Controller.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_ControllersListConnectionDetails_564184;
          apiVersion: string; name: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## controllersListConnectionDetails
  ## Lists connection details for the underlying container resources of an Azure Dev Spaces Controller.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   name: string (required)
  ##       : Name of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID.
  ##   resourceGroupName: string (required)
  ##                    : Resource group to which the resource belongs.
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "name", newJString(name))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  result = call_564192.call(path_564193, query_564194, nil, nil, nil)

var controllersListConnectionDetails* = Call_ControllersListConnectionDetails_564184(
    name: "controllersListConnectionDetails", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevSpaces/controllers/{name}/listConnectionDetails",
    validator: validate_ControllersListConnectionDetails_564185, base: "",
    url: url_ControllersListConnectionDetails_564186, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
