
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: customproviders
## version: 2018-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Allows extension of ARM control plane with custom resource providers.
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
  macServiceName = "customproviders"
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
  ## The list of operations provided by Microsoft CustomProviders.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
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
  ## The list of operations provided by Microsoft CustomProviders.
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
  ## The list of operations provided by Microsoft CustomProviders.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.CustomProviders/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_CustomResourceProviderListBySubscription_568175 = ref object of OpenApiRestCall_567657
proc url_CustomResourceProviderListBySubscription_568177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/resourceProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomResourceProviderListBySubscription_568176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the custom resource providers within a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
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
  ##              : The API version to be used with the HTTP request.
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

proc call*(call_568194: Call_CustomResourceProviderListBySubscription_568175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the custom resource providers within a subscription.
  ## 
  let valid = call_568194.validator(path, query, header, formData, body)
  let scheme = call_568194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568194.url(scheme.get, call_568194.host, call_568194.base,
                         call_568194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568194, url, valid)

proc call*(call_568195: Call_CustomResourceProviderListBySubscription_568175;
          apiVersion: string; subscriptionId: string): Recallable =
  ## customResourceProviderListBySubscription
  ## Gets all the custom resource providers within a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_568196 = newJObject()
  var query_568197 = newJObject()
  add(query_568197, "api-version", newJString(apiVersion))
  add(path_568196, "subscriptionId", newJString(subscriptionId))
  result = call_568195.call(path_568196, query_568197, nil, nil, nil)

var customResourceProviderListBySubscription* = Call_CustomResourceProviderListBySubscription_568175(
    name: "customResourceProviderListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.CustomProviders/resourceProviders",
    validator: validate_CustomResourceProviderListBySubscription_568176, base: "",
    url: url_CustomResourceProviderListBySubscription_568177,
    schemes: {Scheme.Https})
type
  Call_CustomResourceProviderListByResourceGroup_568198 = ref object of OpenApiRestCall_567657
proc url_CustomResourceProviderListByResourceGroup_568200(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/resourceProviders")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomResourceProviderListByResourceGroup_568199(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the custom resource providers within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
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
  ##              : The API version to be used with the HTTP request.
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

proc call*(call_568204: Call_CustomResourceProviderListByResourceGroup_568198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the custom resource providers within a resource group.
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_CustomResourceProviderListByResourceGroup_568198;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## customResourceProviderListByResourceGroup
  ## Gets all the custom resource providers within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(path_568206, "resourceGroupName", newJString(resourceGroupName))
  add(query_568207, "api-version", newJString(apiVersion))
  add(path_568206, "subscriptionId", newJString(subscriptionId))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var customResourceProviderListByResourceGroup* = Call_CustomResourceProviderListByResourceGroup_568198(
    name: "customResourceProviderListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomProviders/resourceProviders",
    validator: validate_CustomResourceProviderListByResourceGroup_568199,
    base: "", url: url_CustomResourceProviderListByResourceGroup_568200,
    schemes: {Scheme.Https})
type
  Call_CustomResourceProviderCreateOrUpdate_568219 = ref object of OpenApiRestCall_567657
proc url_CustomResourceProviderCreateOrUpdate_568221(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderName" in path,
        "`resourceProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/resourceProviders/"),
               (kind: VariableSegment, value: "resourceProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomResourceProviderCreateOrUpdate_568220(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the custom resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceProviderName: JString (required)
  ##                       : The name of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568239 = path.getOrDefault("resourceGroupName")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "resourceGroupName", valid_568239
  var valid_568240 = path.getOrDefault("resourceProviderName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceProviderName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
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
  ##   resourceProvider: JObject (required)
  ##                   : The parameters required to create or update a custom resource provider definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_CustomResourceProviderCreateOrUpdate_568219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the custom resource provider.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_CustomResourceProviderCreateOrUpdate_568219;
          resourceGroupName: string; resourceProviderName: string;
          apiVersion: string; subscriptionId: string; resourceProvider: JsonNode): Recallable =
  ## customResourceProviderCreateOrUpdate
  ## Creates or updates the custom resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceProviderName: string (required)
  ##                       : The name of the resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   resourceProvider: JObject (required)
  ##                   : The parameters required to create or update a custom resource provider definition.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  var body_568248 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(path_568246, "resourceProviderName", newJString(resourceProviderName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  if resourceProvider != nil:
    body_568248 = resourceProvider
  result = call_568245.call(path_568246, query_568247, nil, nil, body_568248)

var customResourceProviderCreateOrUpdate* = Call_CustomResourceProviderCreateOrUpdate_568219(
    name: "customResourceProviderCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomProviders/resourceProviders/{resourceProviderName}",
    validator: validate_CustomResourceProviderCreateOrUpdate_568220, base: "",
    url: url_CustomResourceProviderCreateOrUpdate_568221, schemes: {Scheme.Https})
type
  Call_CustomResourceProviderGet_568208 = ref object of OpenApiRestCall_567657
proc url_CustomResourceProviderGet_568210(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderName" in path,
        "`resourceProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/resourceProviders/"),
               (kind: VariableSegment, value: "resourceProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomResourceProviderGet_568209(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the custom resource provider manifest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceProviderName: JString (required)
  ##                       : The name of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568211 = path.getOrDefault("resourceGroupName")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceGroupName", valid_568211
  var valid_568212 = path.getOrDefault("resourceProviderName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceProviderName", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
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

proc call*(call_568215: Call_CustomResourceProviderGet_568208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the custom resource provider manifest.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_CustomResourceProviderGet_568208;
          resourceGroupName: string; resourceProviderName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## customResourceProviderGet
  ## Gets the custom resource provider manifest.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceProviderName: string (required)
  ##                       : The name of the resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(path_568217, "resourceGroupName", newJString(resourceGroupName))
  add(path_568217, "resourceProviderName", newJString(resourceProviderName))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var customResourceProviderGet* = Call_CustomResourceProviderGet_568208(
    name: "customResourceProviderGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomProviders/resourceProviders/{resourceProviderName}",
    validator: validate_CustomResourceProviderGet_568209, base: "",
    url: url_CustomResourceProviderGet_568210, schemes: {Scheme.Https})
type
  Call_CustomResourceProviderUpdate_568260 = ref object of OpenApiRestCall_567657
proc url_CustomResourceProviderUpdate_568262(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderName" in path,
        "`resourceProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/resourceProviders/"),
               (kind: VariableSegment, value: "resourceProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomResourceProviderUpdate_568261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom resource provider. The only value that can be updated via PATCH currently is the tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceProviderName: JString (required)
  ##                       : The name of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568263 = path.getOrDefault("resourceGroupName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "resourceGroupName", valid_568263
  var valid_568264 = path.getOrDefault("resourceProviderName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceProviderName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
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
  ##   patchableResource: JObject (required)
  ##                    : The updatable fields of a custom resource provider.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_CustomResourceProviderUpdate_568260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing custom resource provider. The only value that can be updated via PATCH currently is the tags.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_CustomResourceProviderUpdate_568260;
          resourceGroupName: string; resourceProviderName: string;
          apiVersion: string; subscriptionId: string; patchableResource: JsonNode): Recallable =
  ## customResourceProviderUpdate
  ## Updates an existing custom resource provider. The only value that can be updated via PATCH currently is the tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceProviderName: string (required)
  ##                       : The name of the resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  ##   patchableResource: JObject (required)
  ##                    : The updatable fields of a custom resource provider.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  var body_568272 = newJObject()
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(path_568270, "resourceProviderName", newJString(resourceProviderName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  if patchableResource != nil:
    body_568272 = patchableResource
  result = call_568269.call(path_568270, query_568271, nil, nil, body_568272)

var customResourceProviderUpdate* = Call_CustomResourceProviderUpdate_568260(
    name: "customResourceProviderUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomProviders/resourceProviders/{resourceProviderName}",
    validator: validate_CustomResourceProviderUpdate_568261, base: "",
    url: url_CustomResourceProviderUpdate_568262, schemes: {Scheme.Https})
type
  Call_CustomResourceProviderDelete_568249 = ref object of OpenApiRestCall_567657
proc url_CustomResourceProviderDelete_568251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderName" in path,
        "`resourceProviderName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/resourceProviders/"),
               (kind: VariableSegment, value: "resourceProviderName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomResourceProviderDelete_568250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the custom resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceProviderName: JString (required)
  ##                       : The name of the resource provider.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("resourceProviderName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceProviderName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
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

proc call*(call_568256: Call_CustomResourceProviderDelete_568249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the custom resource provider.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_CustomResourceProviderDelete_568249;
          resourceGroupName: string; resourceProviderName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## customResourceProviderDelete
  ## Deletes the custom resource provider.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceProviderName: string (required)
  ##                       : The name of the resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID. This is a GUID-formatted string (e.g. 00000000-0000-0000-0000-000000000000)
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(path_568258, "resourceProviderName", newJString(resourceProviderName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var customResourceProviderDelete* = Call_CustomResourceProviderDelete_568249(
    name: "customResourceProviderDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.CustomProviders/resourceProviders/{resourceProviderName}",
    validator: validate_CustomResourceProviderDelete_568250, base: "",
    url: url_CustomResourceProviderDelete_568251, schemes: {Scheme.Https})
type
  Call_AssociationsListAll_568273 = ref object of OpenApiRestCall_567657
proc url_AssociationsListAll_568275(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/associations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssociationsListAll_568274(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all association for the given scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the association.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568276 = path.getOrDefault("scope")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "scope", valid_568276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568277 = query.getOrDefault("api-version")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "api-version", valid_568277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568278: Call_AssociationsListAll_568273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all association for the given scope.
  ## 
  let valid = call_568278.validator(path, query, header, formData, body)
  let scheme = call_568278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568278.url(scheme.get, call_568278.host, call_568278.base,
                         call_568278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568278, url, valid)

proc call*(call_568279: Call_AssociationsListAll_568273; apiVersion: string;
          scope: string): Recallable =
  ## associationsListAll
  ## Gets all association for the given scope.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   scope: string (required)
  ##        : The scope of the association.
  var path_568280 = newJObject()
  var query_568281 = newJObject()
  add(query_568281, "api-version", newJString(apiVersion))
  add(path_568280, "scope", newJString(scope))
  result = call_568279.call(path_568280, query_568281, nil, nil, nil)

var associationsListAll* = Call_AssociationsListAll_568273(
    name: "associationsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.CustomProviders/associations",
    validator: validate_AssociationsListAll_568274, base: "",
    url: url_AssociationsListAll_568275, schemes: {Scheme.Https})
type
  Call_AssociationsCreateOrUpdate_568292 = ref object of OpenApiRestCall_567657
proc url_AssociationsCreateOrUpdate_568294(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/associations/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssociationsCreateOrUpdate_568293(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an association.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the association. The scope can be any valid REST resource instance. For example, use 
  ## '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Compute/virtualMachines/{vm-name}' for a virtual machine resource.
  ##   associationName: JString (required)
  ##                  : The name of the association.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568295 = path.getOrDefault("scope")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "scope", valid_568295
  var valid_568296 = path.getOrDefault("associationName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "associationName", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568297 = query.getOrDefault("api-version")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "api-version", valid_568297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   association: JObject (required)
  ##              : The parameters required to create or update an association.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_AssociationsCreateOrUpdate_568292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an association.
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_AssociationsCreateOrUpdate_568292; apiVersion: string;
          association: JsonNode; scope: string; associationName: string): Recallable =
  ## associationsCreateOrUpdate
  ## Create or update an association.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   association: JObject (required)
  ##              : The parameters required to create or update an association.
  ##   scope: string (required)
  ##        : The scope of the association. The scope can be any valid REST resource instance. For example, use 
  ## '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Compute/virtualMachines/{vm-name}' for a virtual machine resource.
  ##   associationName: string (required)
  ##                  : The name of the association.
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  var body_568303 = newJObject()
  add(query_568302, "api-version", newJString(apiVersion))
  if association != nil:
    body_568303 = association
  add(path_568301, "scope", newJString(scope))
  add(path_568301, "associationName", newJString(associationName))
  result = call_568300.call(path_568301, query_568302, nil, nil, body_568303)

var associationsCreateOrUpdate* = Call_AssociationsCreateOrUpdate_568292(
    name: "associationsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.CustomProviders/associations/{associationName}",
    validator: validate_AssociationsCreateOrUpdate_568293, base: "",
    url: url_AssociationsCreateOrUpdate_568294, schemes: {Scheme.Https})
type
  Call_AssociationsGet_568282 = ref object of OpenApiRestCall_567657
proc url_AssociationsGet_568284(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/associations/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssociationsGet_568283(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get an association.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the association.
  ##   associationName: JString (required)
  ##                  : The name of the association.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568285 = path.getOrDefault("scope")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "scope", valid_568285
  var valid_568286 = path.getOrDefault("associationName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "associationName", valid_568286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568287 = query.getOrDefault("api-version")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "api-version", valid_568287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568288: Call_AssociationsGet_568282; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an association.
  ## 
  let valid = call_568288.validator(path, query, header, formData, body)
  let scheme = call_568288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568288.url(scheme.get, call_568288.host, call_568288.base,
                         call_568288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568288, url, valid)

proc call*(call_568289: Call_AssociationsGet_568282; apiVersion: string;
          scope: string; associationName: string): Recallable =
  ## associationsGet
  ## Get an association.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   scope: string (required)
  ##        : The scope of the association.
  ##   associationName: string (required)
  ##                  : The name of the association.
  var path_568290 = newJObject()
  var query_568291 = newJObject()
  add(query_568291, "api-version", newJString(apiVersion))
  add(path_568290, "scope", newJString(scope))
  add(path_568290, "associationName", newJString(associationName))
  result = call_568289.call(path_568290, query_568291, nil, nil, nil)

var associationsGet* = Call_AssociationsGet_568282(name: "associationsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{scope}/providers/Microsoft.CustomProviders/associations/{associationName}",
    validator: validate_AssociationsGet_568283, base: "", url: url_AssociationsGet_568284,
    schemes: {Scheme.Https})
type
  Call_AssociationsDelete_568304 = ref object of OpenApiRestCall_567657
proc url_AssociationsDelete_568306(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.CustomProviders/associations/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AssociationsDelete_568305(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Delete an association.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The scope of the association.
  ##   associationName: JString (required)
  ##                  : The name of the association.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568307 = path.getOrDefault("scope")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "scope", valid_568307
  var valid_568308 = path.getOrDefault("associationName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "associationName", valid_568308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to be used with the HTTP request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568309 = query.getOrDefault("api-version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "api-version", valid_568309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568310: Call_AssociationsDelete_568304; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an association.
  ## 
  let valid = call_568310.validator(path, query, header, formData, body)
  let scheme = call_568310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568310.url(scheme.get, call_568310.host, call_568310.base,
                         call_568310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568310, url, valid)

proc call*(call_568311: Call_AssociationsDelete_568304; apiVersion: string;
          scope: string; associationName: string): Recallable =
  ## associationsDelete
  ## Delete an association.
  ##   apiVersion: string (required)
  ##             : The API version to be used with the HTTP request.
  ##   scope: string (required)
  ##        : The scope of the association.
  ##   associationName: string (required)
  ##                  : The name of the association.
  var path_568312 = newJObject()
  var query_568313 = newJObject()
  add(query_568313, "api-version", newJString(apiVersion))
  add(path_568312, "scope", newJString(scope))
  add(path_568312, "associationName", newJString(associationName))
  result = call_568311.call(path_568312, query_568313, nil, nil, nil)

var associationsDelete* = Call_AssociationsDelete_568304(
    name: "associationsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.CustomProviders/associations/{associationName}",
    validator: validate_AssociationsDelete_568305, base: "",
    url: url_AssociationsDelete_568306, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
