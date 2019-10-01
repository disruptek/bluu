
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: DataFactoryManagementClient
## version: 2018-06-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_567668 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567668](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567668): Option[Scheme] {.used.} =
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
  macServiceName = "datafactory"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567890 = ref object of OpenApiRestCall_567668
proc url_OperationsList_567892(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567891(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists the available Azure Data Factory API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568051 = query.getOrDefault("api-version")
  valid_568051 = validateParameter(valid_568051, JString, required = true,
                                 default = nil)
  if valid_568051 != nil:
    section.add "api-version", valid_568051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568074: Call_OperationsList_567890; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Azure Data Factory API operations.
  ## 
  let valid = call_568074.validator(path, query, header, formData, body)
  let scheme = call_568074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568074.url(scheme.get, call_568074.host, call_568074.base,
                         call_568074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568074, url, valid)

proc call*(call_568145: Call_OperationsList_567890; apiVersion: string): Recallable =
  ## operationsList
  ## Lists the available Azure Data Factory API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_568146 = newJObject()
  add(query_568146, "api-version", newJString(apiVersion))
  result = call_568145.call(nil, query_568146, nil, nil, nil)

var operationsList* = Call_OperationsList_567890(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataFactory/operations",
    validator: validate_OperationsList_567891, base: "", url: url_OperationsList_567892,
    schemes: {Scheme.Https})
type
  Call_FactoriesList_568186 = ref object of OpenApiRestCall_567668
proc url_FactoriesList_568188(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.DataFactory/factories")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesList_568187(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists factories under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_FactoriesList_568186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories under the specified subscription.
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_FactoriesList_568186; apiVersion: string;
          subscriptionId: string): Recallable =
  ## factoriesList
  ## Lists factories under the specified subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var factoriesList* = Call_FactoriesList_568186(name: "factoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesList_568187, base: "", url: url_FactoriesList_568188,
    schemes: {Scheme.Https})
type
  Call_FactoriesConfigureFactoryRepo_568209 = ref object of OpenApiRestCall_567668
proc url_FactoriesConfigureFactoryRepo_568211(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationId" in path, "`locationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/locations/"),
               (kind: VariableSegment, value: "locationId"),
               (kind: ConstantSegment, value: "/configureFactoryRepo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesConfigureFactoryRepo_568210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a factory's repo information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationId: JString (required)
  ##             : The location identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationId` field"
  var valid_568229 = path.getOrDefault("locationId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "locationId", valid_568229
  var valid_568230 = path.getOrDefault("subscriptionId")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "subscriptionId", valid_568230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   factoryRepoUpdate: JObject (required)
  ##                    : Update factory repo request definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_FactoriesConfigureFactoryRepo_568209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory's repo information.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_FactoriesConfigureFactoryRepo_568209;
          apiVersion: string; locationId: string; subscriptionId: string;
          factoryRepoUpdate: JsonNode): Recallable =
  ## factoriesConfigureFactoryRepo
  ## Updates a factory's repo information.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   locationId: string (required)
  ##             : The location identifier.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   factoryRepoUpdate: JObject (required)
  ##                    : Update factory repo request definition.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  var body_568237 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "locationId", newJString(locationId))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  if factoryRepoUpdate != nil:
    body_568237 = factoryRepoUpdate
  result = call_568234.call(path_568235, query_568236, nil, nil, body_568237)

var factoriesConfigureFactoryRepo* = Call_FactoriesConfigureFactoryRepo_568209(
    name: "factoriesConfigureFactoryRepo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/locations/{locationId}/configureFactoryRepo",
    validator: validate_FactoriesConfigureFactoryRepo_568210, base: "",
    url: url_FactoriesConfigureFactoryRepo_568211, schemes: {Scheme.Https})
type
  Call_ExposureControlGetFeatureValue_568238 = ref object of OpenApiRestCall_567668
proc url_ExposureControlGetFeatureValue_568240(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationId" in path, "`locationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/locations/"),
               (kind: VariableSegment, value: "locationId"),
               (kind: ConstantSegment, value: "/getFeatureValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExposureControlGetFeatureValue_568239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get exposure control feature for specific location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationId: JString (required)
  ##             : The location identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationId` field"
  var valid_568241 = path.getOrDefault("locationId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "locationId", valid_568241
  var valid_568242 = path.getOrDefault("subscriptionId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "subscriptionId", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exposureControlRequest: JObject (required)
  ##                         : The exposure control request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_ExposureControlGetFeatureValue_568238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get exposure control feature for specific location.
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_ExposureControlGetFeatureValue_568238;
          apiVersion: string; locationId: string; subscriptionId: string;
          exposureControlRequest: JsonNode): Recallable =
  ## exposureControlGetFeatureValue
  ## Get exposure control feature for specific location.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   locationId: string (required)
  ##             : The location identifier.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   exposureControlRequest: JObject (required)
  ##                         : The exposure control request.
  var path_568247 = newJObject()
  var query_568248 = newJObject()
  var body_568249 = newJObject()
  add(query_568248, "api-version", newJString(apiVersion))
  add(path_568247, "locationId", newJString(locationId))
  add(path_568247, "subscriptionId", newJString(subscriptionId))
  if exposureControlRequest != nil:
    body_568249 = exposureControlRequest
  result = call_568246.call(path_568247, query_568248, nil, nil, body_568249)

var exposureControlGetFeatureValue* = Call_ExposureControlGetFeatureValue_568238(
    name: "exposureControlGetFeatureValue", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/locations/{locationId}/getFeatureValue",
    validator: validate_ExposureControlGetFeatureValue_568239, base: "",
    url: url_ExposureControlGetFeatureValue_568240, schemes: {Scheme.Https})
type
  Call_FactoriesListByResourceGroup_568250 = ref object of OpenApiRestCall_567668
proc url_FactoriesListByResourceGroup_568252(protocol: Scheme; host: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.DataFactory/factories")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesListByResourceGroup_568251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists factories.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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

proc call*(call_568256: Call_FactoriesListByResourceGroup_568250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories.
  ## 
  let valid = call_568256.validator(path, query, header, formData, body)
  let scheme = call_568256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568256.url(scheme.get, call_568256.host, call_568256.base,
                         call_568256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568256, url, valid)

proc call*(call_568257: Call_FactoriesListByResourceGroup_568250;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## factoriesListByResourceGroup
  ## Lists factories.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568258 = newJObject()
  var query_568259 = newJObject()
  add(path_568258, "resourceGroupName", newJString(resourceGroupName))
  add(query_568259, "api-version", newJString(apiVersion))
  add(path_568258, "subscriptionId", newJString(subscriptionId))
  result = call_568257.call(path_568258, query_568259, nil, nil, nil)

var factoriesListByResourceGroup* = Call_FactoriesListByResourceGroup_568250(
    name: "factoriesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesListByResourceGroup_568251, base: "",
    url: url_FactoriesListByResourceGroup_568252, schemes: {Scheme.Https})
type
  Call_FactoriesCreateOrUpdate_568272 = ref object of OpenApiRestCall_567668
proc url_FactoriesCreateOrUpdate_568274(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesCreateOrUpdate_568273(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568275 = path.getOrDefault("resourceGroupName")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "resourceGroupName", valid_568275
  var valid_568276 = path.getOrDefault("factoryName")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "factoryName", valid_568276
  var valid_568277 = path.getOrDefault("subscriptionId")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "subscriptionId", valid_568277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568278 = query.getOrDefault("api-version")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "api-version", valid_568278
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the factory entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568279 = header.getOrDefault("If-Match")
  valid_568279 = validateParameter(valid_568279, JString, required = false,
                                 default = nil)
  if valid_568279 != nil:
    section.add "If-Match", valid_568279
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   factory: JObject (required)
  ##          : Factory resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_FactoriesCreateOrUpdate_568272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a factory.
  ## 
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_FactoriesCreateOrUpdate_568272;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; factory: JsonNode): Recallable =
  ## factoriesCreateOrUpdate
  ## Creates or updates a factory.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   factory: JObject (required)
  ##          : Factory resource definition.
  var path_568283 = newJObject()
  var query_568284 = newJObject()
  var body_568285 = newJObject()
  add(path_568283, "resourceGroupName", newJString(resourceGroupName))
  add(path_568283, "factoryName", newJString(factoryName))
  add(query_568284, "api-version", newJString(apiVersion))
  add(path_568283, "subscriptionId", newJString(subscriptionId))
  if factory != nil:
    body_568285 = factory
  result = call_568282.call(path_568283, query_568284, nil, nil, body_568285)

var factoriesCreateOrUpdate* = Call_FactoriesCreateOrUpdate_568272(
    name: "factoriesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesCreateOrUpdate_568273, base: "",
    url: url_FactoriesCreateOrUpdate_568274, schemes: {Scheme.Https})
type
  Call_FactoriesGet_568260 = ref object of OpenApiRestCall_567668
proc url_FactoriesGet_568262(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesGet_568261(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568263 = path.getOrDefault("resourceGroupName")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "resourceGroupName", valid_568263
  var valid_568264 = path.getOrDefault("factoryName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "factoryName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568266 = query.getOrDefault("api-version")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "api-version", valid_568266
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the factory entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_568267 = header.getOrDefault("If-None-Match")
  valid_568267 = validateParameter(valid_568267, JString, required = false,
                                 default = nil)
  if valid_568267 != nil:
    section.add "If-None-Match", valid_568267
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568268: Call_FactoriesGet_568260; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a factory.
  ## 
  let valid = call_568268.validator(path, query, header, formData, body)
  let scheme = call_568268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568268.url(scheme.get, call_568268.host, call_568268.base,
                         call_568268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568268, url, valid)

proc call*(call_568269: Call_FactoriesGet_568260; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## factoriesGet
  ## Gets a factory.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568270 = newJObject()
  var query_568271 = newJObject()
  add(path_568270, "resourceGroupName", newJString(resourceGroupName))
  add(path_568270, "factoryName", newJString(factoryName))
  add(query_568271, "api-version", newJString(apiVersion))
  add(path_568270, "subscriptionId", newJString(subscriptionId))
  result = call_568269.call(path_568270, query_568271, nil, nil, nil)

var factoriesGet* = Call_FactoriesGet_568260(name: "factoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesGet_568261, base: "", url: url_FactoriesGet_568262,
    schemes: {Scheme.Https})
type
  Call_FactoriesUpdate_568297 = ref object of OpenApiRestCall_567668
proc url_FactoriesUpdate_568299(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesUpdate_568298(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568300 = path.getOrDefault("resourceGroupName")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "resourceGroupName", valid_568300
  var valid_568301 = path.getOrDefault("factoryName")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "factoryName", valid_568301
  var valid_568302 = path.getOrDefault("subscriptionId")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "subscriptionId", valid_568302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568303 = query.getOrDefault("api-version")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "api-version", valid_568303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   factoryUpdateParameters: JObject (required)
  ##                          : The parameters for updating a factory.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_FactoriesUpdate_568297; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory.
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_FactoriesUpdate_568297; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          factoryUpdateParameters: JsonNode): Recallable =
  ## factoriesUpdate
  ## Updates a factory.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   factoryUpdateParameters: JObject (required)
  ##                          : The parameters for updating a factory.
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  var body_568309 = newJObject()
  add(path_568307, "resourceGroupName", newJString(resourceGroupName))
  add(path_568307, "factoryName", newJString(factoryName))
  add(query_568308, "api-version", newJString(apiVersion))
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  if factoryUpdateParameters != nil:
    body_568309 = factoryUpdateParameters
  result = call_568306.call(path_568307, query_568308, nil, nil, body_568309)

var factoriesUpdate* = Call_FactoriesUpdate_568297(name: "factoriesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesUpdate_568298, base: "", url: url_FactoriesUpdate_568299,
    schemes: {Scheme.Https})
type
  Call_FactoriesDelete_568286 = ref object of OpenApiRestCall_567668
proc url_FactoriesDelete_568288(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesDelete_568287(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568289 = path.getOrDefault("resourceGroupName")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "resourceGroupName", valid_568289
  var valid_568290 = path.getOrDefault("factoryName")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = nil)
  if valid_568290 != nil:
    section.add "factoryName", valid_568290
  var valid_568291 = path.getOrDefault("subscriptionId")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "subscriptionId", valid_568291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  if body != nil:
    result.add "body", body

proc call*(call_568293: Call_FactoriesDelete_568286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a factory.
  ## 
  let valid = call_568293.validator(path, query, header, formData, body)
  let scheme = call_568293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568293.url(scheme.get, call_568293.host, call_568293.base,
                         call_568293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568293, url, valid)

proc call*(call_568294: Call_FactoriesDelete_568286; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## factoriesDelete
  ## Deletes a factory.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568295 = newJObject()
  var query_568296 = newJObject()
  add(path_568295, "resourceGroupName", newJString(resourceGroupName))
  add(path_568295, "factoryName", newJString(factoryName))
  add(query_568296, "api-version", newJString(apiVersion))
  add(path_568295, "subscriptionId", newJString(subscriptionId))
  result = call_568294.call(path_568295, query_568296, nil, nil, nil)

var factoriesDelete* = Call_FactoriesDelete_568286(name: "factoriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesDelete_568287, base: "", url: url_FactoriesDelete_568288,
    schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionAddDataFlow_568310 = ref object of OpenApiRestCall_567668
proc url_DataFlowDebugSessionAddDataFlow_568312(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/addDataFlowToDebugSession")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataFlowDebugSessionAddDataFlow_568311(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a data flow into debug session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568313 = path.getOrDefault("resourceGroupName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "resourceGroupName", valid_568313
  var valid_568314 = path.getOrDefault("factoryName")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "factoryName", valid_568314
  var valid_568315 = path.getOrDefault("subscriptionId")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "subscriptionId", valid_568315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568316 = query.getOrDefault("api-version")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = nil)
  if valid_568316 != nil:
    section.add "api-version", valid_568316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : Data flow debug session definition with debug content.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_DataFlowDebugSessionAddDataFlow_568310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a data flow into debug session.
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_DataFlowDebugSessionAddDataFlow_568310;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; request: JsonNode): Recallable =
  ## dataFlowDebugSessionAddDataFlow
  ## Add a data flow into debug session.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   request: JObject (required)
  ##          : Data flow debug session definition with debug content.
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  var body_568322 = newJObject()
  add(path_568320, "resourceGroupName", newJString(resourceGroupName))
  add(path_568320, "factoryName", newJString(factoryName))
  add(query_568321, "api-version", newJString(apiVersion))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_568322 = request
  result = call_568319.call(path_568320, query_568321, nil, nil, body_568322)

var dataFlowDebugSessionAddDataFlow* = Call_DataFlowDebugSessionAddDataFlow_568310(
    name: "dataFlowDebugSessionAddDataFlow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/addDataFlowToDebugSession",
    validator: validate_DataFlowDebugSessionAddDataFlow_568311, base: "",
    url: url_DataFlowDebugSessionAddDataFlow_568312, schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionCreate_568323 = ref object of OpenApiRestCall_567668
proc url_DataFlowDebugSessionCreate_568325(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/createDataFlowDebugSession")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataFlowDebugSessionCreate_568324(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a data flow debug session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568326 = path.getOrDefault("resourceGroupName")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "resourceGroupName", valid_568326
  var valid_568327 = path.getOrDefault("factoryName")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "factoryName", valid_568327
  var valid_568328 = path.getOrDefault("subscriptionId")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "subscriptionId", valid_568328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : Data flow debug session definition
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568331: Call_DataFlowDebugSessionCreate_568323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a data flow debug session.
  ## 
  let valid = call_568331.validator(path, query, header, formData, body)
  let scheme = call_568331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568331.url(scheme.get, call_568331.host, call_568331.base,
                         call_568331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568331, url, valid)

proc call*(call_568332: Call_DataFlowDebugSessionCreate_568323;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; request: JsonNode): Recallable =
  ## dataFlowDebugSessionCreate
  ## Creates a data flow debug session.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   request: JObject (required)
  ##          : Data flow debug session definition
  var path_568333 = newJObject()
  var query_568334 = newJObject()
  var body_568335 = newJObject()
  add(path_568333, "resourceGroupName", newJString(resourceGroupName))
  add(path_568333, "factoryName", newJString(factoryName))
  add(query_568334, "api-version", newJString(apiVersion))
  add(path_568333, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_568335 = request
  result = call_568332.call(path_568333, query_568334, nil, nil, body_568335)

var dataFlowDebugSessionCreate* = Call_DataFlowDebugSessionCreate_568323(
    name: "dataFlowDebugSessionCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/createDataFlowDebugSession",
    validator: validate_DataFlowDebugSessionCreate_568324, base: "",
    url: url_DataFlowDebugSessionCreate_568325, schemes: {Scheme.Https})
type
  Call_DataFlowsListByFactory_568336 = ref object of OpenApiRestCall_567668
proc url_DataFlowsListByFactory_568338(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/dataflows")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataFlowsListByFactory_568337(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists data flows.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568339 = path.getOrDefault("resourceGroupName")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "resourceGroupName", valid_568339
  var valid_568340 = path.getOrDefault("factoryName")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = nil)
  if valid_568340 != nil:
    section.add "factoryName", valid_568340
  var valid_568341 = path.getOrDefault("subscriptionId")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "subscriptionId", valid_568341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568343: Call_DataFlowsListByFactory_568336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists data flows.
  ## 
  let valid = call_568343.validator(path, query, header, formData, body)
  let scheme = call_568343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568343.url(scheme.get, call_568343.host, call_568343.base,
                         call_568343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568343, url, valid)

proc call*(call_568344: Call_DataFlowsListByFactory_568336;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## dataFlowsListByFactory
  ## Lists data flows.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568345 = newJObject()
  var query_568346 = newJObject()
  add(path_568345, "resourceGroupName", newJString(resourceGroupName))
  add(path_568345, "factoryName", newJString(factoryName))
  add(query_568346, "api-version", newJString(apiVersion))
  add(path_568345, "subscriptionId", newJString(subscriptionId))
  result = call_568344.call(path_568345, query_568346, nil, nil, nil)

var dataFlowsListByFactory* = Call_DataFlowsListByFactory_568336(
    name: "dataFlowsListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/dataflows",
    validator: validate_DataFlowsListByFactory_568337, base: "",
    url: url_DataFlowsListByFactory_568338, schemes: {Scheme.Https})
type
  Call_DataFlowsCreateOrUpdate_568360 = ref object of OpenApiRestCall_567668
proc url_DataFlowsCreateOrUpdate_568362(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "dataFlowName" in path, "`dataFlowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/dataflows/"),
               (kind: VariableSegment, value: "dataFlowName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataFlowsCreateOrUpdate_568361(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a data flow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: JString (required)
  ##               : The data flow name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568363 = path.getOrDefault("resourceGroupName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "resourceGroupName", valid_568363
  var valid_568364 = path.getOrDefault("factoryName")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "factoryName", valid_568364
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  var valid_568366 = path.getOrDefault("dataFlowName")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "dataFlowName", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the data flow entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568368 = header.getOrDefault("If-Match")
  valid_568368 = validateParameter(valid_568368, JString, required = false,
                                 default = nil)
  if valid_568368 != nil:
    section.add "If-Match", valid_568368
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataFlow: JObject (required)
  ##           : Data flow resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_DataFlowsCreateOrUpdate_568360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a data flow.
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_DataFlowsCreateOrUpdate_568360;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          dataFlow: JsonNode; subscriptionId: string; dataFlowName: string): Recallable =
  ## dataFlowsCreateOrUpdate
  ## Creates or updates a data flow.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   dataFlow: JObject (required)
  ##           : Data flow resource definition.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: string (required)
  ##               : The data flow name.
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  var body_568374 = newJObject()
  add(path_568372, "resourceGroupName", newJString(resourceGroupName))
  add(path_568372, "factoryName", newJString(factoryName))
  add(query_568373, "api-version", newJString(apiVersion))
  if dataFlow != nil:
    body_568374 = dataFlow
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(path_568372, "dataFlowName", newJString(dataFlowName))
  result = call_568371.call(path_568372, query_568373, nil, nil, body_568374)

var dataFlowsCreateOrUpdate* = Call_DataFlowsCreateOrUpdate_568360(
    name: "dataFlowsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/dataflows/{dataFlowName}",
    validator: validate_DataFlowsCreateOrUpdate_568361, base: "",
    url: url_DataFlowsCreateOrUpdate_568362, schemes: {Scheme.Https})
type
  Call_DataFlowsGet_568347 = ref object of OpenApiRestCall_567668
proc url_DataFlowsGet_568349(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "dataFlowName" in path, "`dataFlowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/dataflows/"),
               (kind: VariableSegment, value: "dataFlowName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataFlowsGet_568348(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a data flow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: JString (required)
  ##               : The data flow name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568350 = path.getOrDefault("resourceGroupName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "resourceGroupName", valid_568350
  var valid_568351 = path.getOrDefault("factoryName")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "factoryName", valid_568351
  var valid_568352 = path.getOrDefault("subscriptionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "subscriptionId", valid_568352
  var valid_568353 = path.getOrDefault("dataFlowName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "dataFlowName", valid_568353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568354 = query.getOrDefault("api-version")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "api-version", valid_568354
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the data flow entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_568355 = header.getOrDefault("If-None-Match")
  valid_568355 = validateParameter(valid_568355, JString, required = false,
                                 default = nil)
  if valid_568355 != nil:
    section.add "If-None-Match", valid_568355
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568356: Call_DataFlowsGet_568347; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a data flow.
  ## 
  let valid = call_568356.validator(path, query, header, formData, body)
  let scheme = call_568356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568356.url(scheme.get, call_568356.host, call_568356.base,
                         call_568356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568356, url, valid)

proc call*(call_568357: Call_DataFlowsGet_568347; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          dataFlowName: string): Recallable =
  ## dataFlowsGet
  ## Gets a data flow.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: string (required)
  ##               : The data flow name.
  var path_568358 = newJObject()
  var query_568359 = newJObject()
  add(path_568358, "resourceGroupName", newJString(resourceGroupName))
  add(path_568358, "factoryName", newJString(factoryName))
  add(query_568359, "api-version", newJString(apiVersion))
  add(path_568358, "subscriptionId", newJString(subscriptionId))
  add(path_568358, "dataFlowName", newJString(dataFlowName))
  result = call_568357.call(path_568358, query_568359, nil, nil, nil)

var dataFlowsGet* = Call_DataFlowsGet_568347(name: "dataFlowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/dataflows/{dataFlowName}",
    validator: validate_DataFlowsGet_568348, base: "", url: url_DataFlowsGet_568349,
    schemes: {Scheme.Https})
type
  Call_DataFlowsDelete_568375 = ref object of OpenApiRestCall_567668
proc url_DataFlowsDelete_568377(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "dataFlowName" in path, "`dataFlowName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/dataflows/"),
               (kind: VariableSegment, value: "dataFlowName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataFlowsDelete_568376(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a data flow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: JString (required)
  ##               : The data flow name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568378 = path.getOrDefault("resourceGroupName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "resourceGroupName", valid_568378
  var valid_568379 = path.getOrDefault("factoryName")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "factoryName", valid_568379
  var valid_568380 = path.getOrDefault("subscriptionId")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "subscriptionId", valid_568380
  var valid_568381 = path.getOrDefault("dataFlowName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "dataFlowName", valid_568381
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568382 = query.getOrDefault("api-version")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "api-version", valid_568382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568383: Call_DataFlowsDelete_568375; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a data flow.
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_DataFlowsDelete_568375; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          dataFlowName: string): Recallable =
  ## dataFlowsDelete
  ## Deletes a data flow.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: string (required)
  ##               : The data flow name.
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  add(path_568385, "resourceGroupName", newJString(resourceGroupName))
  add(path_568385, "factoryName", newJString(factoryName))
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "subscriptionId", newJString(subscriptionId))
  add(path_568385, "dataFlowName", newJString(dataFlowName))
  result = call_568384.call(path_568385, query_568386, nil, nil, nil)

var dataFlowsDelete* = Call_DataFlowsDelete_568375(name: "dataFlowsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/dataflows/{dataFlowName}",
    validator: validate_DataFlowsDelete_568376, base: "", url: url_DataFlowsDelete_568377,
    schemes: {Scheme.Https})
type
  Call_DatasetsListByFactory_568387 = ref object of OpenApiRestCall_567668
proc url_DatasetsListByFactory_568389(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/datasets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatasetsListByFactory_568388(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists datasets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568390 = path.getOrDefault("resourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "resourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("factoryName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "factoryName", valid_568391
  var valid_568392 = path.getOrDefault("subscriptionId")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "subscriptionId", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = nil)
  if valid_568393 != nil:
    section.add "api-version", valid_568393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_DatasetsListByFactory_568387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists datasets.
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_DatasetsListByFactory_568387;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## datasetsListByFactory
  ## Lists datasets.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  add(path_568396, "resourceGroupName", newJString(resourceGroupName))
  add(path_568396, "factoryName", newJString(factoryName))
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  result = call_568395.call(path_568396, query_568397, nil, nil, nil)

var datasetsListByFactory* = Call_DatasetsListByFactory_568387(
    name: "datasetsListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets",
    validator: validate_DatasetsListByFactory_568388, base: "",
    url: url_DatasetsListByFactory_568389, schemes: {Scheme.Https})
type
  Call_DatasetsCreateOrUpdate_568411 = ref object of OpenApiRestCall_567668
proc url_DatasetsCreateOrUpdate_568413(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "datasetName" in path, "`datasetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatasetsCreateOrUpdate_568412(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   datasetName: JString (required)
  ##              : The dataset name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568414 = path.getOrDefault("resourceGroupName")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "resourceGroupName", valid_568414
  var valid_568415 = path.getOrDefault("factoryName")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "factoryName", valid_568415
  var valid_568416 = path.getOrDefault("subscriptionId")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "subscriptionId", valid_568416
  var valid_568417 = path.getOrDefault("datasetName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "datasetName", valid_568417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568418 = query.getOrDefault("api-version")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "api-version", valid_568418
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the dataset entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568419 = header.getOrDefault("If-Match")
  valid_568419 = validateParameter(valid_568419, JString, required = false,
                                 default = nil)
  if valid_568419 != nil:
    section.add "If-Match", valid_568419
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataset: JObject (required)
  ##          : Dataset resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568421: Call_DatasetsCreateOrUpdate_568411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a dataset.
  ## 
  let valid = call_568421.validator(path, query, header, formData, body)
  let scheme = call_568421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568421.url(scheme.get, call_568421.host, call_568421.base,
                         call_568421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568421, url, valid)

proc call*(call_568422: Call_DatasetsCreateOrUpdate_568411;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; datasetName: string; dataset: JsonNode): Recallable =
  ## datasetsCreateOrUpdate
  ## Creates or updates a dataset.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   datasetName: string (required)
  ##              : The dataset name.
  ##   dataset: JObject (required)
  ##          : Dataset resource definition.
  var path_568423 = newJObject()
  var query_568424 = newJObject()
  var body_568425 = newJObject()
  add(path_568423, "resourceGroupName", newJString(resourceGroupName))
  add(path_568423, "factoryName", newJString(factoryName))
  add(query_568424, "api-version", newJString(apiVersion))
  add(path_568423, "subscriptionId", newJString(subscriptionId))
  add(path_568423, "datasetName", newJString(datasetName))
  if dataset != nil:
    body_568425 = dataset
  result = call_568422.call(path_568423, query_568424, nil, nil, body_568425)

var datasetsCreateOrUpdate* = Call_DatasetsCreateOrUpdate_568411(
    name: "datasetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsCreateOrUpdate_568412, base: "",
    url: url_DatasetsCreateOrUpdate_568413, schemes: {Scheme.Https})
type
  Call_DatasetsGet_568398 = ref object of OpenApiRestCall_567668
proc url_DatasetsGet_568400(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "datasetName" in path, "`datasetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatasetsGet_568399(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   datasetName: JString (required)
  ##              : The dataset name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568401 = path.getOrDefault("resourceGroupName")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "resourceGroupName", valid_568401
  var valid_568402 = path.getOrDefault("factoryName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "factoryName", valid_568402
  var valid_568403 = path.getOrDefault("subscriptionId")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "subscriptionId", valid_568403
  var valid_568404 = path.getOrDefault("datasetName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "datasetName", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "api-version", valid_568405
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the dataset entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_568406 = header.getOrDefault("If-None-Match")
  valid_568406 = validateParameter(valid_568406, JString, required = false,
                                 default = nil)
  if valid_568406 != nil:
    section.add "If-None-Match", valid_568406
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568407: Call_DatasetsGet_568398; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a dataset.
  ## 
  let valid = call_568407.validator(path, query, header, formData, body)
  let scheme = call_568407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568407.url(scheme.get, call_568407.host, call_568407.base,
                         call_568407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568407, url, valid)

proc call*(call_568408: Call_DatasetsGet_568398; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          datasetName: string): Recallable =
  ## datasetsGet
  ## Gets a dataset.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   datasetName: string (required)
  ##              : The dataset name.
  var path_568409 = newJObject()
  var query_568410 = newJObject()
  add(path_568409, "resourceGroupName", newJString(resourceGroupName))
  add(path_568409, "factoryName", newJString(factoryName))
  add(query_568410, "api-version", newJString(apiVersion))
  add(path_568409, "subscriptionId", newJString(subscriptionId))
  add(path_568409, "datasetName", newJString(datasetName))
  result = call_568408.call(path_568409, query_568410, nil, nil, nil)

var datasetsGet* = Call_DatasetsGet_568398(name: "datasetsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
                                        validator: validate_DatasetsGet_568399,
                                        base: "", url: url_DatasetsGet_568400,
                                        schemes: {Scheme.Https})
type
  Call_DatasetsDelete_568426 = ref object of OpenApiRestCall_567668
proc url_DatasetsDelete_568428(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "datasetName" in path, "`datasetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/datasets/"),
               (kind: VariableSegment, value: "datasetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatasetsDelete_568427(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   datasetName: JString (required)
  ##              : The dataset name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568429 = path.getOrDefault("resourceGroupName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "resourceGroupName", valid_568429
  var valid_568430 = path.getOrDefault("factoryName")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "factoryName", valid_568430
  var valid_568431 = path.getOrDefault("subscriptionId")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "subscriptionId", valid_568431
  var valid_568432 = path.getOrDefault("datasetName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "datasetName", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568434: Call_DatasetsDelete_568426; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a dataset.
  ## 
  let valid = call_568434.validator(path, query, header, formData, body)
  let scheme = call_568434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568434.url(scheme.get, call_568434.host, call_568434.base,
                         call_568434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568434, url, valid)

proc call*(call_568435: Call_DatasetsDelete_568426; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          datasetName: string): Recallable =
  ## datasetsDelete
  ## Deletes a dataset.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   datasetName: string (required)
  ##              : The dataset name.
  var path_568436 = newJObject()
  var query_568437 = newJObject()
  add(path_568436, "resourceGroupName", newJString(resourceGroupName))
  add(path_568436, "factoryName", newJString(factoryName))
  add(query_568437, "api-version", newJString(apiVersion))
  add(path_568436, "subscriptionId", newJString(subscriptionId))
  add(path_568436, "datasetName", newJString(datasetName))
  result = call_568435.call(path_568436, query_568437, nil, nil, nil)

var datasetsDelete* = Call_DatasetsDelete_568426(name: "datasetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsDelete_568427, base: "", url: url_DatasetsDelete_568428,
    schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionDelete_568438 = ref object of OpenApiRestCall_567668
proc url_DataFlowDebugSessionDelete_568440(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/deleteDataFlowDebugSession")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataFlowDebugSessionDelete_568439(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a data flow debug session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568441 = path.getOrDefault("resourceGroupName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "resourceGroupName", valid_568441
  var valid_568442 = path.getOrDefault("factoryName")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "factoryName", valid_568442
  var valid_568443 = path.getOrDefault("subscriptionId")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "subscriptionId", valid_568443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568444 = query.getOrDefault("api-version")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "api-version", valid_568444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : Data flow debug session definition for deletion
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568446: Call_DataFlowDebugSessionDelete_568438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a data flow debug session.
  ## 
  let valid = call_568446.validator(path, query, header, formData, body)
  let scheme = call_568446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568446.url(scheme.get, call_568446.host, call_568446.base,
                         call_568446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568446, url, valid)

proc call*(call_568447: Call_DataFlowDebugSessionDelete_568438;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; request: JsonNode): Recallable =
  ## dataFlowDebugSessionDelete
  ## Deletes a data flow debug session.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   request: JObject (required)
  ##          : Data flow debug session definition for deletion
  var path_568448 = newJObject()
  var query_568449 = newJObject()
  var body_568450 = newJObject()
  add(path_568448, "resourceGroupName", newJString(resourceGroupName))
  add(path_568448, "factoryName", newJString(factoryName))
  add(query_568449, "api-version", newJString(apiVersion))
  add(path_568448, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_568450 = request
  result = call_568447.call(path_568448, query_568449, nil, nil, body_568450)

var dataFlowDebugSessionDelete* = Call_DataFlowDebugSessionDelete_568438(
    name: "dataFlowDebugSessionDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/deleteDataFlowDebugSession",
    validator: validate_DataFlowDebugSessionDelete_568439, base: "",
    url: url_DataFlowDebugSessionDelete_568440, schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionExecuteCommand_568451 = ref object of OpenApiRestCall_567668
proc url_DataFlowDebugSessionExecuteCommand_568453(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/executeDataFlowDebugCommand")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataFlowDebugSessionExecuteCommand_568452(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute a data flow debug command.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568454 = path.getOrDefault("resourceGroupName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "resourceGroupName", valid_568454
  var valid_568455 = path.getOrDefault("factoryName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "factoryName", valid_568455
  var valid_568456 = path.getOrDefault("subscriptionId")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "subscriptionId", valid_568456
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568457 = query.getOrDefault("api-version")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "api-version", valid_568457
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   request: JObject (required)
  ##          : Data flow debug command definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568459: Call_DataFlowDebugSessionExecuteCommand_568451;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Execute a data flow debug command.
  ## 
  let valid = call_568459.validator(path, query, header, formData, body)
  let scheme = call_568459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568459.url(scheme.get, call_568459.host, call_568459.base,
                         call_568459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568459, url, valid)

proc call*(call_568460: Call_DataFlowDebugSessionExecuteCommand_568451;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; request: JsonNode): Recallable =
  ## dataFlowDebugSessionExecuteCommand
  ## Execute a data flow debug command.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   request: JObject (required)
  ##          : Data flow debug command definition.
  var path_568461 = newJObject()
  var query_568462 = newJObject()
  var body_568463 = newJObject()
  add(path_568461, "resourceGroupName", newJString(resourceGroupName))
  add(path_568461, "factoryName", newJString(factoryName))
  add(query_568462, "api-version", newJString(apiVersion))
  add(path_568461, "subscriptionId", newJString(subscriptionId))
  if request != nil:
    body_568463 = request
  result = call_568460.call(path_568461, query_568462, nil, nil, body_568463)

var dataFlowDebugSessionExecuteCommand* = Call_DataFlowDebugSessionExecuteCommand_568451(
    name: "dataFlowDebugSessionExecuteCommand", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/executeDataFlowDebugCommand",
    validator: validate_DataFlowDebugSessionExecuteCommand_568452, base: "",
    url: url_DataFlowDebugSessionExecuteCommand_568453, schemes: {Scheme.Https})
type
  Call_FactoriesGetDataPlaneAccess_568464 = ref object of OpenApiRestCall_567668
proc url_FactoriesGetDataPlaneAccess_568466(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/getDataPlaneAccess")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesGetDataPlaneAccess_568465(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Data Plane access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568467 = path.getOrDefault("resourceGroupName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "resourceGroupName", valid_568467
  var valid_568468 = path.getOrDefault("factoryName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "factoryName", valid_568468
  var valid_568469 = path.getOrDefault("subscriptionId")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "subscriptionId", valid_568469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "api-version", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   policy: JObject (required)
  ##         : Data Plane user access policy definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568472: Call_FactoriesGetDataPlaneAccess_568464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Data Plane access.
  ## 
  let valid = call_568472.validator(path, query, header, formData, body)
  let scheme = call_568472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568472.url(scheme.get, call_568472.host, call_568472.base,
                         call_568472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568472, url, valid)

proc call*(call_568473: Call_FactoriesGetDataPlaneAccess_568464;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; policy: JsonNode): Recallable =
  ## factoriesGetDataPlaneAccess
  ## Get Data Plane access.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   policy: JObject (required)
  ##         : Data Plane user access policy definition.
  var path_568474 = newJObject()
  var query_568475 = newJObject()
  var body_568476 = newJObject()
  add(path_568474, "resourceGroupName", newJString(resourceGroupName))
  add(path_568474, "factoryName", newJString(factoryName))
  add(query_568475, "api-version", newJString(apiVersion))
  add(path_568474, "subscriptionId", newJString(subscriptionId))
  if policy != nil:
    body_568476 = policy
  result = call_568473.call(path_568474, query_568475, nil, nil, body_568476)

var factoriesGetDataPlaneAccess* = Call_FactoriesGetDataPlaneAccess_568464(
    name: "factoriesGetDataPlaneAccess", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/getDataPlaneAccess",
    validator: validate_FactoriesGetDataPlaneAccess_568465, base: "",
    url: url_FactoriesGetDataPlaneAccess_568466, schemes: {Scheme.Https})
type
  Call_ExposureControlGetFeatureValueByFactory_568477 = ref object of OpenApiRestCall_567668
proc url_ExposureControlGetFeatureValueByFactory_568479(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/getFeatureValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExposureControlGetFeatureValueByFactory_568478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get exposure control feature for specific factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568480 = path.getOrDefault("resourceGroupName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "resourceGroupName", valid_568480
  var valid_568481 = path.getOrDefault("factoryName")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "factoryName", valid_568481
  var valid_568482 = path.getOrDefault("subscriptionId")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "subscriptionId", valid_568482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568483 = query.getOrDefault("api-version")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "api-version", valid_568483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   exposureControlRequest: JObject (required)
  ##                         : The exposure control request.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568485: Call_ExposureControlGetFeatureValueByFactory_568477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get exposure control feature for specific factory.
  ## 
  let valid = call_568485.validator(path, query, header, formData, body)
  let scheme = call_568485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568485.url(scheme.get, call_568485.host, call_568485.base,
                         call_568485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568485, url, valid)

proc call*(call_568486: Call_ExposureControlGetFeatureValueByFactory_568477;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; exposureControlRequest: JsonNode): Recallable =
  ## exposureControlGetFeatureValueByFactory
  ## Get exposure control feature for specific factory.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   exposureControlRequest: JObject (required)
  ##                         : The exposure control request.
  var path_568487 = newJObject()
  var query_568488 = newJObject()
  var body_568489 = newJObject()
  add(path_568487, "resourceGroupName", newJString(resourceGroupName))
  add(path_568487, "factoryName", newJString(factoryName))
  add(query_568488, "api-version", newJString(apiVersion))
  add(path_568487, "subscriptionId", newJString(subscriptionId))
  if exposureControlRequest != nil:
    body_568489 = exposureControlRequest
  result = call_568486.call(path_568487, query_568488, nil, nil, body_568489)

var exposureControlGetFeatureValueByFactory* = Call_ExposureControlGetFeatureValueByFactory_568477(
    name: "exposureControlGetFeatureValueByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/getFeatureValue",
    validator: validate_ExposureControlGetFeatureValueByFactory_568478, base: "",
    url: url_ExposureControlGetFeatureValueByFactory_568479,
    schemes: {Scheme.Https})
type
  Call_FactoriesGetGitHubAccessToken_568490 = ref object of OpenApiRestCall_567668
proc url_FactoriesGetGitHubAccessToken_568492(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/getGitHubAccessToken")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesGetGitHubAccessToken_568491(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get GitHub Access Token.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568493 = path.getOrDefault("resourceGroupName")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "resourceGroupName", valid_568493
  var valid_568494 = path.getOrDefault("factoryName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "factoryName", valid_568494
  var valid_568495 = path.getOrDefault("subscriptionId")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "subscriptionId", valid_568495
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568496 = query.getOrDefault("api-version")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "api-version", valid_568496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   gitHubAccessTokenRequest: JObject (required)
  ##                           : Get GitHub access token request definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568498: Call_FactoriesGetGitHubAccessToken_568490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get GitHub Access Token.
  ## 
  let valid = call_568498.validator(path, query, header, formData, body)
  let scheme = call_568498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568498.url(scheme.get, call_568498.host, call_568498.base,
                         call_568498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568498, url, valid)

proc call*(call_568499: Call_FactoriesGetGitHubAccessToken_568490;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; gitHubAccessTokenRequest: JsonNode): Recallable =
  ## factoriesGetGitHubAccessToken
  ## Get GitHub Access Token.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   gitHubAccessTokenRequest: JObject (required)
  ##                           : Get GitHub access token request definition.
  var path_568500 = newJObject()
  var query_568501 = newJObject()
  var body_568502 = newJObject()
  add(path_568500, "resourceGroupName", newJString(resourceGroupName))
  add(path_568500, "factoryName", newJString(factoryName))
  add(query_568501, "api-version", newJString(apiVersion))
  add(path_568500, "subscriptionId", newJString(subscriptionId))
  if gitHubAccessTokenRequest != nil:
    body_568502 = gitHubAccessTokenRequest
  result = call_568499.call(path_568500, query_568501, nil, nil, body_568502)

var factoriesGetGitHubAccessToken* = Call_FactoriesGetGitHubAccessToken_568490(
    name: "factoriesGetGitHubAccessToken", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/getGitHubAccessToken",
    validator: validate_FactoriesGetGitHubAccessToken_568491, base: "",
    url: url_FactoriesGetGitHubAccessToken_568492, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListByFactory_568503 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesListByFactory_568505(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesListByFactory_568504(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists integration runtimes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568506 = path.getOrDefault("resourceGroupName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "resourceGroupName", valid_568506
  var valid_568507 = path.getOrDefault("factoryName")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "factoryName", valid_568507
  var valid_568508 = path.getOrDefault("subscriptionId")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "subscriptionId", valid_568508
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568509 = query.getOrDefault("api-version")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "api-version", valid_568509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568510: Call_IntegrationRuntimesListByFactory_568503;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists integration runtimes.
  ## 
  let valid = call_568510.validator(path, query, header, formData, body)
  let scheme = call_568510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568510.url(scheme.get, call_568510.host, call_568510.base,
                         call_568510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568510, url, valid)

proc call*(call_568511: Call_IntegrationRuntimesListByFactory_568503;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## integrationRuntimesListByFactory
  ## Lists integration runtimes.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568512 = newJObject()
  var query_568513 = newJObject()
  add(path_568512, "resourceGroupName", newJString(resourceGroupName))
  add(path_568512, "factoryName", newJString(factoryName))
  add(query_568513, "api-version", newJString(apiVersion))
  add(path_568512, "subscriptionId", newJString(subscriptionId))
  result = call_568511.call(path_568512, query_568513, nil, nil, nil)

var integrationRuntimesListByFactory* = Call_IntegrationRuntimesListByFactory_568503(
    name: "integrationRuntimesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes",
    validator: validate_IntegrationRuntimesListByFactory_568504, base: "",
    url: url_IntegrationRuntimesListByFactory_568505, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesCreateOrUpdate_568527 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesCreateOrUpdate_568529(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesCreateOrUpdate_568528(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568530 = path.getOrDefault("resourceGroupName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "resourceGroupName", valid_568530
  var valid_568531 = path.getOrDefault("factoryName")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "factoryName", valid_568531
  var valid_568532 = path.getOrDefault("integrationRuntimeName")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "integrationRuntimeName", valid_568532
  var valid_568533 = path.getOrDefault("subscriptionId")
  valid_568533 = validateParameter(valid_568533, JString, required = true,
                                 default = nil)
  if valid_568533 != nil:
    section.add "subscriptionId", valid_568533
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568534 = query.getOrDefault("api-version")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "api-version", valid_568534
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the integration runtime entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568535 = header.getOrDefault("If-Match")
  valid_568535 = validateParameter(valid_568535, JString, required = false,
                                 default = nil)
  if valid_568535 != nil:
    section.add "If-Match", valid_568535
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   integrationRuntime: JObject (required)
  ##                     : Integration runtime resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568537: Call_IntegrationRuntimesCreateOrUpdate_568527;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration runtime.
  ## 
  let valid = call_568537.validator(path, query, header, formData, body)
  let scheme = call_568537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568537.url(scheme.get, call_568537.host, call_568537.base,
                         call_568537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568537, url, valid)

proc call*(call_568538: Call_IntegrationRuntimesCreateOrUpdate_568527;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          integrationRuntime: JsonNode): Recallable =
  ## integrationRuntimesCreateOrUpdate
  ## Creates or updates an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   integrationRuntime: JObject (required)
  ##                     : Integration runtime resource definition.
  var path_568539 = newJObject()
  var query_568540 = newJObject()
  var body_568541 = newJObject()
  add(path_568539, "resourceGroupName", newJString(resourceGroupName))
  add(path_568539, "factoryName", newJString(factoryName))
  add(query_568540, "api-version", newJString(apiVersion))
  add(path_568539, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568539, "subscriptionId", newJString(subscriptionId))
  if integrationRuntime != nil:
    body_568541 = integrationRuntime
  result = call_568538.call(path_568539, query_568540, nil, nil, body_568541)

var integrationRuntimesCreateOrUpdate* = Call_IntegrationRuntimesCreateOrUpdate_568527(
    name: "integrationRuntimesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesCreateOrUpdate_568528, base: "",
    url: url_IntegrationRuntimesCreateOrUpdate_568529, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGet_568514 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesGet_568516(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesGet_568515(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568517 = path.getOrDefault("resourceGroupName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "resourceGroupName", valid_568517
  var valid_568518 = path.getOrDefault("factoryName")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "factoryName", valid_568518
  var valid_568519 = path.getOrDefault("integrationRuntimeName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "integrationRuntimeName", valid_568519
  var valid_568520 = path.getOrDefault("subscriptionId")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "subscriptionId", valid_568520
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568521 = query.getOrDefault("api-version")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "api-version", valid_568521
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the integration runtime entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_568522 = header.getOrDefault("If-None-Match")
  valid_568522 = validateParameter(valid_568522, JString, required = false,
                                 default = nil)
  if valid_568522 != nil:
    section.add "If-None-Match", valid_568522
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568523: Call_IntegrationRuntimesGet_568514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration runtime.
  ## 
  let valid = call_568523.validator(path, query, header, formData, body)
  let scheme = call_568523.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568523.url(scheme.get, call_568523.host, call_568523.base,
                         call_568523.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568523, url, valid)

proc call*(call_568524: Call_IntegrationRuntimesGet_568514;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesGet
  ## Gets an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568525 = newJObject()
  var query_568526 = newJObject()
  add(path_568525, "resourceGroupName", newJString(resourceGroupName))
  add(path_568525, "factoryName", newJString(factoryName))
  add(query_568526, "api-version", newJString(apiVersion))
  add(path_568525, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568525, "subscriptionId", newJString(subscriptionId))
  result = call_568524.call(path_568525, query_568526, nil, nil, nil)

var integrationRuntimesGet* = Call_IntegrationRuntimesGet_568514(
    name: "integrationRuntimesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesGet_568515, base: "",
    url: url_IntegrationRuntimesGet_568516, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpdate_568554 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesUpdate_568556(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesUpdate_568555(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568557 = path.getOrDefault("resourceGroupName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "resourceGroupName", valid_568557
  var valid_568558 = path.getOrDefault("factoryName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "factoryName", valid_568558
  var valid_568559 = path.getOrDefault("integrationRuntimeName")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "integrationRuntimeName", valid_568559
  var valid_568560 = path.getOrDefault("subscriptionId")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "subscriptionId", valid_568560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568561 = query.getOrDefault("api-version")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "api-version", valid_568561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateIntegrationRuntimeRequest: JObject (required)
  ##                                  : The parameters for updating an integration runtime.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568563: Call_IntegrationRuntimesUpdate_568554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration runtime.
  ## 
  let valid = call_568563.validator(path, query, header, formData, body)
  let scheme = call_568563.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568563.url(scheme.get, call_568563.host, call_568563.base,
                         call_568563.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568563, url, valid)

proc call*(call_568564: Call_IntegrationRuntimesUpdate_568554;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          updateIntegrationRuntimeRequest: JsonNode): Recallable =
  ## integrationRuntimesUpdate
  ## Updates an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   updateIntegrationRuntimeRequest: JObject (required)
  ##                                  : The parameters for updating an integration runtime.
  var path_568565 = newJObject()
  var query_568566 = newJObject()
  var body_568567 = newJObject()
  add(path_568565, "resourceGroupName", newJString(resourceGroupName))
  add(path_568565, "factoryName", newJString(factoryName))
  add(query_568566, "api-version", newJString(apiVersion))
  add(path_568565, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568565, "subscriptionId", newJString(subscriptionId))
  if updateIntegrationRuntimeRequest != nil:
    body_568567 = updateIntegrationRuntimeRequest
  result = call_568564.call(path_568565, query_568566, nil, nil, body_568567)

var integrationRuntimesUpdate* = Call_IntegrationRuntimesUpdate_568554(
    name: "integrationRuntimesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesUpdate_568555, base: "",
    url: url_IntegrationRuntimesUpdate_568556, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesDelete_568542 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesDelete_568544(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesDelete_568543(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568545 = path.getOrDefault("resourceGroupName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "resourceGroupName", valid_568545
  var valid_568546 = path.getOrDefault("factoryName")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "factoryName", valid_568546
  var valid_568547 = path.getOrDefault("integrationRuntimeName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "integrationRuntimeName", valid_568547
  var valid_568548 = path.getOrDefault("subscriptionId")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "subscriptionId", valid_568548
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568549 = query.getOrDefault("api-version")
  valid_568549 = validateParameter(valid_568549, JString, required = true,
                                 default = nil)
  if valid_568549 != nil:
    section.add "api-version", valid_568549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568550: Call_IntegrationRuntimesDelete_568542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration runtime.
  ## 
  let valid = call_568550.validator(path, query, header, formData, body)
  let scheme = call_568550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568550.url(scheme.get, call_568550.host, call_568550.base,
                         call_568550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568550, url, valid)

proc call*(call_568551: Call_IntegrationRuntimesDelete_568542;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesDelete
  ## Deletes an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568552 = newJObject()
  var query_568553 = newJObject()
  add(path_568552, "resourceGroupName", newJString(resourceGroupName))
  add(path_568552, "factoryName", newJString(factoryName))
  add(query_568553, "api-version", newJString(apiVersion))
  add(path_568552, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568552, "subscriptionId", newJString(subscriptionId))
  result = call_568551.call(path_568552, query_568553, nil, nil, nil)

var integrationRuntimesDelete* = Call_IntegrationRuntimesDelete_568542(
    name: "integrationRuntimesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesDelete_568543, base: "",
    url: url_IntegrationRuntimesDelete_568544, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetConnectionInfo_568568 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesGetConnectionInfo_568570(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/getConnectionInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesGetConnectionInfo_568569(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568571 = path.getOrDefault("resourceGroupName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "resourceGroupName", valid_568571
  var valid_568572 = path.getOrDefault("factoryName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "factoryName", valid_568572
  var valid_568573 = path.getOrDefault("integrationRuntimeName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "integrationRuntimeName", valid_568573
  var valid_568574 = path.getOrDefault("subscriptionId")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "subscriptionId", valid_568574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568575 = query.getOrDefault("api-version")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "api-version", valid_568575
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568576: Call_IntegrationRuntimesGetConnectionInfo_568568;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ## 
  let valid = call_568576.validator(path, query, header, formData, body)
  let scheme = call_568576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568576.url(scheme.get, call_568576.host, call_568576.base,
                         call_568576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568576, url, valid)

proc call*(call_568577: Call_IntegrationRuntimesGetConnectionInfo_568568;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesGetConnectionInfo
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568578 = newJObject()
  var query_568579 = newJObject()
  add(path_568578, "resourceGroupName", newJString(resourceGroupName))
  add(path_568578, "factoryName", newJString(factoryName))
  add(query_568579, "api-version", newJString(apiVersion))
  add(path_568578, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568578, "subscriptionId", newJString(subscriptionId))
  result = call_568577.call(path_568578, query_568579, nil, nil, nil)

var integrationRuntimesGetConnectionInfo* = Call_IntegrationRuntimesGetConnectionInfo_568568(
    name: "integrationRuntimesGetConnectionInfo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getConnectionInfo",
    validator: validate_IntegrationRuntimesGetConnectionInfo_568569, base: "",
    url: url_IntegrationRuntimesGetConnectionInfo_568570, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeObjectMetadataGet_568580 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimeObjectMetadataGet_568582(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/getObjectMetadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimeObjectMetadataGet_568581(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a SSIS integration runtime object metadata by specified path. The return is pageable metadata list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568583 = path.getOrDefault("resourceGroupName")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "resourceGroupName", valid_568583
  var valid_568584 = path.getOrDefault("factoryName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "factoryName", valid_568584
  var valid_568585 = path.getOrDefault("integrationRuntimeName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "integrationRuntimeName", valid_568585
  var valid_568586 = path.getOrDefault("subscriptionId")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "subscriptionId", valid_568586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568587 = query.getOrDefault("api-version")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "api-version", valid_568587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   getMetadataRequest: JObject
  ##                     : The parameters for getting a SSIS object metadata.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568589: Call_IntegrationRuntimeObjectMetadataGet_568580;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a SSIS integration runtime object metadata by specified path. The return is pageable metadata list.
  ## 
  let valid = call_568589.validator(path, query, header, formData, body)
  let scheme = call_568589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568589.url(scheme.get, call_568589.host, call_568589.base,
                         call_568589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568589, url, valid)

proc call*(call_568590: Call_IntegrationRuntimeObjectMetadataGet_568580;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          getMetadataRequest: JsonNode = nil): Recallable =
  ## integrationRuntimeObjectMetadataGet
  ## Get a SSIS integration runtime object metadata by specified path. The return is pageable metadata list.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   getMetadataRequest: JObject
  ##                     : The parameters for getting a SSIS object metadata.
  var path_568591 = newJObject()
  var query_568592 = newJObject()
  var body_568593 = newJObject()
  add(path_568591, "resourceGroupName", newJString(resourceGroupName))
  add(path_568591, "factoryName", newJString(factoryName))
  add(query_568592, "api-version", newJString(apiVersion))
  add(path_568591, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568591, "subscriptionId", newJString(subscriptionId))
  if getMetadataRequest != nil:
    body_568593 = getMetadataRequest
  result = call_568590.call(path_568591, query_568592, nil, nil, body_568593)

var integrationRuntimeObjectMetadataGet* = Call_IntegrationRuntimeObjectMetadataGet_568580(
    name: "integrationRuntimeObjectMetadataGet", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getObjectMetadata",
    validator: validate_IntegrationRuntimeObjectMetadataGet_568581, base: "",
    url: url_IntegrationRuntimeObjectMetadataGet_568582, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetStatus_568594 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesGetStatus_568596(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/getStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesGetStatus_568595(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets detailed status information for an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568597 = path.getOrDefault("resourceGroupName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "resourceGroupName", valid_568597
  var valid_568598 = path.getOrDefault("factoryName")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "factoryName", valid_568598
  var valid_568599 = path.getOrDefault("integrationRuntimeName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "integrationRuntimeName", valid_568599
  var valid_568600 = path.getOrDefault("subscriptionId")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "subscriptionId", valid_568600
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568601 = query.getOrDefault("api-version")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "api-version", valid_568601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568602: Call_IntegrationRuntimesGetStatus_568594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets detailed status information for an integration runtime.
  ## 
  let valid = call_568602.validator(path, query, header, formData, body)
  let scheme = call_568602.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568602.url(scheme.get, call_568602.host, call_568602.base,
                         call_568602.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568602, url, valid)

proc call*(call_568603: Call_IntegrationRuntimesGetStatus_568594;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesGetStatus
  ## Gets detailed status information for an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568604 = newJObject()
  var query_568605 = newJObject()
  add(path_568604, "resourceGroupName", newJString(resourceGroupName))
  add(path_568604, "factoryName", newJString(factoryName))
  add(query_568605, "api-version", newJString(apiVersion))
  add(path_568604, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568604, "subscriptionId", newJString(subscriptionId))
  result = call_568603.call(path_568604, query_568605, nil, nil, nil)

var integrationRuntimesGetStatus* = Call_IntegrationRuntimesGetStatus_568594(
    name: "integrationRuntimesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getStatus",
    validator: validate_IntegrationRuntimesGetStatus_568595, base: "",
    url: url_IntegrationRuntimesGetStatus_568596, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_568606 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesCreateLinkedIntegrationRuntime_568608(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/linkedIntegrationRuntime")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesCreateLinkedIntegrationRuntime_568607(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create a linked integration runtime entry in a shared integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568609 = path.getOrDefault("resourceGroupName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "resourceGroupName", valid_568609
  var valid_568610 = path.getOrDefault("factoryName")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "factoryName", valid_568610
  var valid_568611 = path.getOrDefault("integrationRuntimeName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "integrationRuntimeName", valid_568611
  var valid_568612 = path.getOrDefault("subscriptionId")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "subscriptionId", valid_568612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568613 = query.getOrDefault("api-version")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "api-version", valid_568613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   createLinkedIntegrationRuntimeRequest: JObject (required)
  ##                                        : The linked integration runtime properties.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568615: Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_568606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a linked integration runtime entry in a shared integration runtime.
  ## 
  let valid = call_568615.validator(path, query, header, formData, body)
  let scheme = call_568615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568615.url(scheme.get, call_568615.host, call_568615.base,
                         call_568615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568615, url, valid)

proc call*(call_568616: Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_568606;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          createLinkedIntegrationRuntimeRequest: JsonNode): Recallable =
  ## integrationRuntimesCreateLinkedIntegrationRuntime
  ## Create a linked integration runtime entry in a shared integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   createLinkedIntegrationRuntimeRequest: JObject (required)
  ##                                        : The linked integration runtime properties.
  var path_568617 = newJObject()
  var query_568618 = newJObject()
  var body_568619 = newJObject()
  add(path_568617, "resourceGroupName", newJString(resourceGroupName))
  add(path_568617, "factoryName", newJString(factoryName))
  add(query_568618, "api-version", newJString(apiVersion))
  add(path_568617, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568617, "subscriptionId", newJString(subscriptionId))
  if createLinkedIntegrationRuntimeRequest != nil:
    body_568619 = createLinkedIntegrationRuntimeRequest
  result = call_568616.call(path_568617, query_568618, nil, nil, body_568619)

var integrationRuntimesCreateLinkedIntegrationRuntime* = Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_568606(
    name: "integrationRuntimesCreateLinkedIntegrationRuntime",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/linkedIntegrationRuntime",
    validator: validate_IntegrationRuntimesCreateLinkedIntegrationRuntime_568607,
    base: "", url: url_IntegrationRuntimesCreateLinkedIntegrationRuntime_568608,
    schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListAuthKeys_568620 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesListAuthKeys_568622(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/listAuthKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesListAuthKeys_568621(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the authentication keys for an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568623 = path.getOrDefault("resourceGroupName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "resourceGroupName", valid_568623
  var valid_568624 = path.getOrDefault("factoryName")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "factoryName", valid_568624
  var valid_568625 = path.getOrDefault("integrationRuntimeName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "integrationRuntimeName", valid_568625
  var valid_568626 = path.getOrDefault("subscriptionId")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "subscriptionId", valid_568626
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568627 = query.getOrDefault("api-version")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "api-version", valid_568627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568628: Call_IntegrationRuntimesListAuthKeys_568620;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authentication keys for an integration runtime.
  ## 
  let valid = call_568628.validator(path, query, header, formData, body)
  let scheme = call_568628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568628.url(scheme.get, call_568628.host, call_568628.base,
                         call_568628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568628, url, valid)

proc call*(call_568629: Call_IntegrationRuntimesListAuthKeys_568620;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesListAuthKeys
  ## Retrieves the authentication keys for an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568630 = newJObject()
  var query_568631 = newJObject()
  add(path_568630, "resourceGroupName", newJString(resourceGroupName))
  add(path_568630, "factoryName", newJString(factoryName))
  add(query_568631, "api-version", newJString(apiVersion))
  add(path_568630, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568630, "subscriptionId", newJString(subscriptionId))
  result = call_568629.call(path_568630, query_568631, nil, nil, nil)

var integrationRuntimesListAuthKeys* = Call_IntegrationRuntimesListAuthKeys_568620(
    name: "integrationRuntimesListAuthKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/listAuthKeys",
    validator: validate_IntegrationRuntimesListAuthKeys_568621, base: "",
    url: url_IntegrationRuntimesListAuthKeys_568622, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetMonitoringData_568632 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesGetMonitoringData_568634(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/monitoringData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesGetMonitoringData_568633(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568635 = path.getOrDefault("resourceGroupName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "resourceGroupName", valid_568635
  var valid_568636 = path.getOrDefault("factoryName")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "factoryName", valid_568636
  var valid_568637 = path.getOrDefault("integrationRuntimeName")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "integrationRuntimeName", valid_568637
  var valid_568638 = path.getOrDefault("subscriptionId")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "subscriptionId", valid_568638
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568639 = query.getOrDefault("api-version")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "api-version", valid_568639
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568640: Call_IntegrationRuntimesGetMonitoringData_568632;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ## 
  let valid = call_568640.validator(path, query, header, formData, body)
  let scheme = call_568640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568640.url(scheme.get, call_568640.host, call_568640.base,
                         call_568640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568640, url, valid)

proc call*(call_568641: Call_IntegrationRuntimesGetMonitoringData_568632;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesGetMonitoringData
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568642 = newJObject()
  var query_568643 = newJObject()
  add(path_568642, "resourceGroupName", newJString(resourceGroupName))
  add(path_568642, "factoryName", newJString(factoryName))
  add(query_568643, "api-version", newJString(apiVersion))
  add(path_568642, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568642, "subscriptionId", newJString(subscriptionId))
  result = call_568641.call(path_568642, query_568643, nil, nil, nil)

var integrationRuntimesGetMonitoringData* = Call_IntegrationRuntimesGetMonitoringData_568632(
    name: "integrationRuntimesGetMonitoringData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/monitoringData",
    validator: validate_IntegrationRuntimesGetMonitoringData_568633, base: "",
    url: url_IntegrationRuntimesGetMonitoringData_568634, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesGet_568644 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimeNodesGet_568646(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimeNodesGet_568645(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568647 = path.getOrDefault("resourceGroupName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "resourceGroupName", valid_568647
  var valid_568648 = path.getOrDefault("factoryName")
  valid_568648 = validateParameter(valid_568648, JString, required = true,
                                 default = nil)
  if valid_568648 != nil:
    section.add "factoryName", valid_568648
  var valid_568649 = path.getOrDefault("nodeName")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "nodeName", valid_568649
  var valid_568650 = path.getOrDefault("integrationRuntimeName")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "integrationRuntimeName", valid_568650
  var valid_568651 = path.getOrDefault("subscriptionId")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "subscriptionId", valid_568651
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568652 = query.getOrDefault("api-version")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "api-version", valid_568652
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568653: Call_IntegrationRuntimeNodesGet_568644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a self-hosted integration runtime node.
  ## 
  let valid = call_568653.validator(path, query, header, formData, body)
  let scheme = call_568653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568653.url(scheme.get, call_568653.host, call_568653.base,
                         call_568653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568653, url, valid)

proc call*(call_568654: Call_IntegrationRuntimeNodesGet_568644;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          nodeName: string; integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimeNodesGet
  ## Gets a self-hosted integration runtime node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568655 = newJObject()
  var query_568656 = newJObject()
  add(path_568655, "resourceGroupName", newJString(resourceGroupName))
  add(path_568655, "factoryName", newJString(factoryName))
  add(query_568656, "api-version", newJString(apiVersion))
  add(path_568655, "nodeName", newJString(nodeName))
  add(path_568655, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568655, "subscriptionId", newJString(subscriptionId))
  result = call_568654.call(path_568655, query_568656, nil, nil, nil)

var integrationRuntimeNodesGet* = Call_IntegrationRuntimeNodesGet_568644(
    name: "integrationRuntimeNodesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesGet_568645, base: "",
    url: url_IntegrationRuntimeNodesGet_568646, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesUpdate_568670 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimeNodesUpdate_568672(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimeNodesUpdate_568671(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568673 = path.getOrDefault("resourceGroupName")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "resourceGroupName", valid_568673
  var valid_568674 = path.getOrDefault("factoryName")
  valid_568674 = validateParameter(valid_568674, JString, required = true,
                                 default = nil)
  if valid_568674 != nil:
    section.add "factoryName", valid_568674
  var valid_568675 = path.getOrDefault("nodeName")
  valid_568675 = validateParameter(valid_568675, JString, required = true,
                                 default = nil)
  if valid_568675 != nil:
    section.add "nodeName", valid_568675
  var valid_568676 = path.getOrDefault("integrationRuntimeName")
  valid_568676 = validateParameter(valid_568676, JString, required = true,
                                 default = nil)
  if valid_568676 != nil:
    section.add "integrationRuntimeName", valid_568676
  var valid_568677 = path.getOrDefault("subscriptionId")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "subscriptionId", valid_568677
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568678 = query.getOrDefault("api-version")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "api-version", valid_568678
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   updateIntegrationRuntimeNodeRequest: JObject (required)
  ##                                      : The parameters for updating an integration runtime node.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568680: Call_IntegrationRuntimeNodesUpdate_568670; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a self-hosted integration runtime node.
  ## 
  let valid = call_568680.validator(path, query, header, formData, body)
  let scheme = call_568680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568680.url(scheme.get, call_568680.host, call_568680.base,
                         call_568680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568680, url, valid)

proc call*(call_568681: Call_IntegrationRuntimeNodesUpdate_568670;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          nodeName: string; integrationRuntimeName: string; subscriptionId: string;
          updateIntegrationRuntimeNodeRequest: JsonNode): Recallable =
  ## integrationRuntimeNodesUpdate
  ## Updates a self-hosted integration runtime node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   updateIntegrationRuntimeNodeRequest: JObject (required)
  ##                                      : The parameters for updating an integration runtime node.
  var path_568682 = newJObject()
  var query_568683 = newJObject()
  var body_568684 = newJObject()
  add(path_568682, "resourceGroupName", newJString(resourceGroupName))
  add(path_568682, "factoryName", newJString(factoryName))
  add(query_568683, "api-version", newJString(apiVersion))
  add(path_568682, "nodeName", newJString(nodeName))
  add(path_568682, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568682, "subscriptionId", newJString(subscriptionId))
  if updateIntegrationRuntimeNodeRequest != nil:
    body_568684 = updateIntegrationRuntimeNodeRequest
  result = call_568681.call(path_568682, query_568683, nil, nil, body_568684)

var integrationRuntimeNodesUpdate* = Call_IntegrationRuntimeNodesUpdate_568670(
    name: "integrationRuntimeNodesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesUpdate_568671, base: "",
    url: url_IntegrationRuntimeNodesUpdate_568672, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesDelete_568657 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimeNodesDelete_568659(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimeNodesDelete_568658(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568660 = path.getOrDefault("resourceGroupName")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "resourceGroupName", valid_568660
  var valid_568661 = path.getOrDefault("factoryName")
  valid_568661 = validateParameter(valid_568661, JString, required = true,
                                 default = nil)
  if valid_568661 != nil:
    section.add "factoryName", valid_568661
  var valid_568662 = path.getOrDefault("nodeName")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = nil)
  if valid_568662 != nil:
    section.add "nodeName", valid_568662
  var valid_568663 = path.getOrDefault("integrationRuntimeName")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "integrationRuntimeName", valid_568663
  var valid_568664 = path.getOrDefault("subscriptionId")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "subscriptionId", valid_568664
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568665 = query.getOrDefault("api-version")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "api-version", valid_568665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568666: Call_IntegrationRuntimeNodesDelete_568657; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a self-hosted integration runtime node.
  ## 
  let valid = call_568666.validator(path, query, header, formData, body)
  let scheme = call_568666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568666.url(scheme.get, call_568666.host, call_568666.base,
                         call_568666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568666, url, valid)

proc call*(call_568667: Call_IntegrationRuntimeNodesDelete_568657;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          nodeName: string; integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimeNodesDelete
  ## Deletes a self-hosted integration runtime node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568668 = newJObject()
  var query_568669 = newJObject()
  add(path_568668, "resourceGroupName", newJString(resourceGroupName))
  add(path_568668, "factoryName", newJString(factoryName))
  add(query_568669, "api-version", newJString(apiVersion))
  add(path_568668, "nodeName", newJString(nodeName))
  add(path_568668, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568668, "subscriptionId", newJString(subscriptionId))
  result = call_568667.call(path_568668, query_568669, nil, nil, nil)

var integrationRuntimeNodesDelete* = Call_IntegrationRuntimeNodesDelete_568657(
    name: "integrationRuntimeNodesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesDelete_568658, base: "",
    url: url_IntegrationRuntimeNodesDelete_568659, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesGetIpAddress_568685 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimeNodesGetIpAddress_568687(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/ipAddress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimeNodesGetIpAddress_568686(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the IP address of self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568688 = path.getOrDefault("resourceGroupName")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = nil)
  if valid_568688 != nil:
    section.add "resourceGroupName", valid_568688
  var valid_568689 = path.getOrDefault("factoryName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "factoryName", valid_568689
  var valid_568690 = path.getOrDefault("nodeName")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "nodeName", valid_568690
  var valid_568691 = path.getOrDefault("integrationRuntimeName")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "integrationRuntimeName", valid_568691
  var valid_568692 = path.getOrDefault("subscriptionId")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "subscriptionId", valid_568692
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568693 = query.getOrDefault("api-version")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "api-version", valid_568693
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568694: Call_IntegrationRuntimeNodesGetIpAddress_568685;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IP address of self-hosted integration runtime node.
  ## 
  let valid = call_568694.validator(path, query, header, formData, body)
  let scheme = call_568694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568694.url(scheme.get, call_568694.host, call_568694.base,
                         call_568694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568694, url, valid)

proc call*(call_568695: Call_IntegrationRuntimeNodesGetIpAddress_568685;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          nodeName: string; integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimeNodesGetIpAddress
  ## Get the IP address of self-hosted integration runtime node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568696 = newJObject()
  var query_568697 = newJObject()
  add(path_568696, "resourceGroupName", newJString(resourceGroupName))
  add(path_568696, "factoryName", newJString(factoryName))
  add(query_568697, "api-version", newJString(apiVersion))
  add(path_568696, "nodeName", newJString(nodeName))
  add(path_568696, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568696, "subscriptionId", newJString(subscriptionId))
  result = call_568695.call(path_568696, query_568697, nil, nil, nil)

var integrationRuntimeNodesGetIpAddress* = Call_IntegrationRuntimeNodesGetIpAddress_568685(
    name: "integrationRuntimeNodesGetIpAddress", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}/ipAddress",
    validator: validate_IntegrationRuntimeNodesGetIpAddress_568686, base: "",
    url: url_IntegrationRuntimeNodesGetIpAddress_568687, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeObjectMetadataRefresh_568698 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimeObjectMetadataRefresh_568700(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/refreshObjectMetadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimeObjectMetadataRefresh_568699(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refresh a SSIS integration runtime object metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568701 = path.getOrDefault("resourceGroupName")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "resourceGroupName", valid_568701
  var valid_568702 = path.getOrDefault("factoryName")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "factoryName", valid_568702
  var valid_568703 = path.getOrDefault("integrationRuntimeName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "integrationRuntimeName", valid_568703
  var valid_568704 = path.getOrDefault("subscriptionId")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "subscriptionId", valid_568704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568705 = query.getOrDefault("api-version")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "api-version", valid_568705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568706: Call_IntegrationRuntimeObjectMetadataRefresh_568698;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refresh a SSIS integration runtime object metadata.
  ## 
  let valid = call_568706.validator(path, query, header, formData, body)
  let scheme = call_568706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568706.url(scheme.get, call_568706.host, call_568706.base,
                         call_568706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568706, url, valid)

proc call*(call_568707: Call_IntegrationRuntimeObjectMetadataRefresh_568698;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimeObjectMetadataRefresh
  ## Refresh a SSIS integration runtime object metadata.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568708 = newJObject()
  var query_568709 = newJObject()
  add(path_568708, "resourceGroupName", newJString(resourceGroupName))
  add(path_568708, "factoryName", newJString(factoryName))
  add(query_568709, "api-version", newJString(apiVersion))
  add(path_568708, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568708, "subscriptionId", newJString(subscriptionId))
  result = call_568707.call(path_568708, query_568709, nil, nil, nil)

var integrationRuntimeObjectMetadataRefresh* = Call_IntegrationRuntimeObjectMetadataRefresh_568698(
    name: "integrationRuntimeObjectMetadataRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/refreshObjectMetadata",
    validator: validate_IntegrationRuntimeObjectMetadataRefresh_568699, base: "",
    url: url_IntegrationRuntimeObjectMetadataRefresh_568700,
    schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRegenerateAuthKey_568710 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesRegenerateAuthKey_568712(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/regenerateAuthKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesRegenerateAuthKey_568711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the authentication key for an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568713 = path.getOrDefault("resourceGroupName")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "resourceGroupName", valid_568713
  var valid_568714 = path.getOrDefault("factoryName")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "factoryName", valid_568714
  var valid_568715 = path.getOrDefault("integrationRuntimeName")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "integrationRuntimeName", valid_568715
  var valid_568716 = path.getOrDefault("subscriptionId")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "subscriptionId", valid_568716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568717 = query.getOrDefault("api-version")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "api-version", valid_568717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   regenerateKeyParameters: JObject (required)
  ##                          : The parameters for regenerating integration runtime authentication key.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568719: Call_IntegrationRuntimesRegenerateAuthKey_568710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the authentication key for an integration runtime.
  ## 
  let valid = call_568719.validator(path, query, header, formData, body)
  let scheme = call_568719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568719.url(scheme.get, call_568719.host, call_568719.base,
                         call_568719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568719, url, valid)

proc call*(call_568720: Call_IntegrationRuntimesRegenerateAuthKey_568710;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          regenerateKeyParameters: JsonNode; integrationRuntimeName: string;
          subscriptionId: string): Recallable =
  ## integrationRuntimesRegenerateAuthKey
  ## Regenerates the authentication key for an integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   regenerateKeyParameters: JObject (required)
  ##                          : The parameters for regenerating integration runtime authentication key.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568721 = newJObject()
  var query_568722 = newJObject()
  var body_568723 = newJObject()
  add(path_568721, "resourceGroupName", newJString(resourceGroupName))
  add(path_568721, "factoryName", newJString(factoryName))
  add(query_568722, "api-version", newJString(apiVersion))
  if regenerateKeyParameters != nil:
    body_568723 = regenerateKeyParameters
  add(path_568721, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568721, "subscriptionId", newJString(subscriptionId))
  result = call_568720.call(path_568721, query_568722, nil, nil, body_568723)

var integrationRuntimesRegenerateAuthKey* = Call_IntegrationRuntimesRegenerateAuthKey_568710(
    name: "integrationRuntimesRegenerateAuthKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/regenerateAuthKey",
    validator: validate_IntegrationRuntimesRegenerateAuthKey_568711, base: "",
    url: url_IntegrationRuntimesRegenerateAuthKey_568712, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRemoveLinks_568724 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesRemoveLinks_568726(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/removeLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesRemoveLinks_568725(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove all linked integration runtimes under specific data factory in a self-hosted integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568727 = path.getOrDefault("resourceGroupName")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "resourceGroupName", valid_568727
  var valid_568728 = path.getOrDefault("factoryName")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "factoryName", valid_568728
  var valid_568729 = path.getOrDefault("integrationRuntimeName")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "integrationRuntimeName", valid_568729
  var valid_568730 = path.getOrDefault("subscriptionId")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "subscriptionId", valid_568730
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568731 = query.getOrDefault("api-version")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "api-version", valid_568731
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   linkedIntegrationRuntimeRequest: JObject (required)
  ##                                  : The data factory name for the linked integration runtime.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568733: Call_IntegrationRuntimesRemoveLinks_568724; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove all linked integration runtimes under specific data factory in a self-hosted integration runtime.
  ## 
  let valid = call_568733.validator(path, query, header, formData, body)
  let scheme = call_568733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568733.url(scheme.get, call_568733.host, call_568733.base,
                         call_568733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568733, url, valid)

proc call*(call_568734: Call_IntegrationRuntimesRemoveLinks_568724;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          linkedIntegrationRuntimeRequest: JsonNode;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesRemoveLinks
  ## Remove all linked integration runtimes under specific data factory in a self-hosted integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   linkedIntegrationRuntimeRequest: JObject (required)
  ##                                  : The data factory name for the linked integration runtime.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568735 = newJObject()
  var query_568736 = newJObject()
  var body_568737 = newJObject()
  add(path_568735, "resourceGroupName", newJString(resourceGroupName))
  add(path_568735, "factoryName", newJString(factoryName))
  add(query_568736, "api-version", newJString(apiVersion))
  if linkedIntegrationRuntimeRequest != nil:
    body_568737 = linkedIntegrationRuntimeRequest
  add(path_568735, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568735, "subscriptionId", newJString(subscriptionId))
  result = call_568734.call(path_568735, query_568736, nil, nil, body_568737)

var integrationRuntimesRemoveLinks* = Call_IntegrationRuntimesRemoveLinks_568724(
    name: "integrationRuntimesRemoveLinks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/removeLinks",
    validator: validate_IntegrationRuntimesRemoveLinks_568725, base: "",
    url: url_IntegrationRuntimesRemoveLinks_568726, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStart_568738 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesStart_568740(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesStart_568739(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a ManagedReserved type integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568741 = path.getOrDefault("resourceGroupName")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "resourceGroupName", valid_568741
  var valid_568742 = path.getOrDefault("factoryName")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "factoryName", valid_568742
  var valid_568743 = path.getOrDefault("integrationRuntimeName")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = nil)
  if valid_568743 != nil:
    section.add "integrationRuntimeName", valid_568743
  var valid_568744 = path.getOrDefault("subscriptionId")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "subscriptionId", valid_568744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568745 = query.getOrDefault("api-version")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = nil)
  if valid_568745 != nil:
    section.add "api-version", valid_568745
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568746: Call_IntegrationRuntimesStart_568738; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a ManagedReserved type integration runtime.
  ## 
  let valid = call_568746.validator(path, query, header, formData, body)
  let scheme = call_568746.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568746.url(scheme.get, call_568746.host, call_568746.base,
                         call_568746.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568746, url, valid)

proc call*(call_568747: Call_IntegrationRuntimesStart_568738;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesStart
  ## Starts a ManagedReserved type integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568748 = newJObject()
  var query_568749 = newJObject()
  add(path_568748, "resourceGroupName", newJString(resourceGroupName))
  add(path_568748, "factoryName", newJString(factoryName))
  add(query_568749, "api-version", newJString(apiVersion))
  add(path_568748, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568748, "subscriptionId", newJString(subscriptionId))
  result = call_568747.call(path_568748, query_568749, nil, nil, nil)

var integrationRuntimesStart* = Call_IntegrationRuntimesStart_568738(
    name: "integrationRuntimesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/start",
    validator: validate_IntegrationRuntimesStart_568739, base: "",
    url: url_IntegrationRuntimesStart_568740, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStop_568750 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesStop_568752(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesStop_568751(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a ManagedReserved type integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568753 = path.getOrDefault("resourceGroupName")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "resourceGroupName", valid_568753
  var valid_568754 = path.getOrDefault("factoryName")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "factoryName", valid_568754
  var valid_568755 = path.getOrDefault("integrationRuntimeName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "integrationRuntimeName", valid_568755
  var valid_568756 = path.getOrDefault("subscriptionId")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "subscriptionId", valid_568756
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568757 = query.getOrDefault("api-version")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "api-version", valid_568757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568758: Call_IntegrationRuntimesStop_568750; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a ManagedReserved type integration runtime.
  ## 
  let valid = call_568758.validator(path, query, header, formData, body)
  let scheme = call_568758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568758.url(scheme.get, call_568758.host, call_568758.base,
                         call_568758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568758, url, valid)

proc call*(call_568759: Call_IntegrationRuntimesStop_568750;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesStop
  ## Stops a ManagedReserved type integration runtime.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568760 = newJObject()
  var query_568761 = newJObject()
  add(path_568760, "resourceGroupName", newJString(resourceGroupName))
  add(path_568760, "factoryName", newJString(factoryName))
  add(query_568761, "api-version", newJString(apiVersion))
  add(path_568760, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568760, "subscriptionId", newJString(subscriptionId))
  result = call_568759.call(path_568760, query_568761, nil, nil, nil)

var integrationRuntimesStop* = Call_IntegrationRuntimesStop_568750(
    name: "integrationRuntimesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/stop",
    validator: validate_IntegrationRuntimesStop_568751, base: "",
    url: url_IntegrationRuntimesStop_568752, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesSyncCredentials_568762 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesSyncCredentials_568764(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/syncCredentials")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesSyncCredentials_568763(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568765 = path.getOrDefault("resourceGroupName")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "resourceGroupName", valid_568765
  var valid_568766 = path.getOrDefault("factoryName")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "factoryName", valid_568766
  var valid_568767 = path.getOrDefault("integrationRuntimeName")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "integrationRuntimeName", valid_568767
  var valid_568768 = path.getOrDefault("subscriptionId")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "subscriptionId", valid_568768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568769 = query.getOrDefault("api-version")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "api-version", valid_568769
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568770: Call_IntegrationRuntimesSyncCredentials_568762;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ## 
  let valid = call_568770.validator(path, query, header, formData, body)
  let scheme = call_568770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568770.url(scheme.get, call_568770.host, call_568770.base,
                         call_568770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568770, url, valid)

proc call*(call_568771: Call_IntegrationRuntimesSyncCredentials_568762;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesSyncCredentials
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568772 = newJObject()
  var query_568773 = newJObject()
  add(path_568772, "resourceGroupName", newJString(resourceGroupName))
  add(path_568772, "factoryName", newJString(factoryName))
  add(query_568773, "api-version", newJString(apiVersion))
  add(path_568772, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568772, "subscriptionId", newJString(subscriptionId))
  result = call_568771.call(path_568772, query_568773, nil, nil, nil)

var integrationRuntimesSyncCredentials* = Call_IntegrationRuntimesSyncCredentials_568762(
    name: "integrationRuntimesSyncCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/syncCredentials",
    validator: validate_IntegrationRuntimesSyncCredentials_568763, base: "",
    url: url_IntegrationRuntimesSyncCredentials_568764, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpgrade_568774 = ref object of OpenApiRestCall_567668
proc url_IntegrationRuntimesUpgrade_568776(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "integrationRuntimeName" in path,
        "`integrationRuntimeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/integrationRuntimes/"),
               (kind: VariableSegment, value: "integrationRuntimeName"),
               (kind: ConstantSegment, value: "/upgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesUpgrade_568775(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568777 = path.getOrDefault("resourceGroupName")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "resourceGroupName", valid_568777
  var valid_568778 = path.getOrDefault("factoryName")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "factoryName", valid_568778
  var valid_568779 = path.getOrDefault("integrationRuntimeName")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "integrationRuntimeName", valid_568779
  var valid_568780 = path.getOrDefault("subscriptionId")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "subscriptionId", valid_568780
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568781 = query.getOrDefault("api-version")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "api-version", valid_568781
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568782: Call_IntegrationRuntimesUpgrade_568774; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ## 
  let valid = call_568782.validator(path, query, header, formData, body)
  let scheme = call_568782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568782.url(scheme.get, call_568782.host, call_568782.base,
                         call_568782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568782, url, valid)

proc call*(call_568783: Call_IntegrationRuntimesUpgrade_568774;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string): Recallable =
  ## integrationRuntimesUpgrade
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568784 = newJObject()
  var query_568785 = newJObject()
  add(path_568784, "resourceGroupName", newJString(resourceGroupName))
  add(path_568784, "factoryName", newJString(factoryName))
  add(query_568785, "api-version", newJString(apiVersion))
  add(path_568784, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_568784, "subscriptionId", newJString(subscriptionId))
  result = call_568783.call(path_568784, query_568785, nil, nil, nil)

var integrationRuntimesUpgrade* = Call_IntegrationRuntimesUpgrade_568774(
    name: "integrationRuntimesUpgrade", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/upgrade",
    validator: validate_IntegrationRuntimesUpgrade_568775, base: "",
    url: url_IntegrationRuntimesUpgrade_568776, schemes: {Scheme.Https})
type
  Call_LinkedServicesListByFactory_568786 = ref object of OpenApiRestCall_567668
proc url_LinkedServicesListByFactory_568788(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/linkedservices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinkedServicesListByFactory_568787(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists linked services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568789 = path.getOrDefault("resourceGroupName")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "resourceGroupName", valid_568789
  var valid_568790 = path.getOrDefault("factoryName")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = nil)
  if valid_568790 != nil:
    section.add "factoryName", valid_568790
  var valid_568791 = path.getOrDefault("subscriptionId")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = nil)
  if valid_568791 != nil:
    section.add "subscriptionId", valid_568791
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568792 = query.getOrDefault("api-version")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "api-version", valid_568792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568793: Call_LinkedServicesListByFactory_568786; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists linked services.
  ## 
  let valid = call_568793.validator(path, query, header, formData, body)
  let scheme = call_568793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568793.url(scheme.get, call_568793.host, call_568793.base,
                         call_568793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568793, url, valid)

proc call*(call_568794: Call_LinkedServicesListByFactory_568786;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## linkedServicesListByFactory
  ## Lists linked services.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568795 = newJObject()
  var query_568796 = newJObject()
  add(path_568795, "resourceGroupName", newJString(resourceGroupName))
  add(path_568795, "factoryName", newJString(factoryName))
  add(query_568796, "api-version", newJString(apiVersion))
  add(path_568795, "subscriptionId", newJString(subscriptionId))
  result = call_568794.call(path_568795, query_568796, nil, nil, nil)

var linkedServicesListByFactory* = Call_LinkedServicesListByFactory_568786(
    name: "linkedServicesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices",
    validator: validate_LinkedServicesListByFactory_568787, base: "",
    url: url_LinkedServicesListByFactory_568788, schemes: {Scheme.Https})
type
  Call_LinkedServicesCreateOrUpdate_568810 = ref object of OpenApiRestCall_567668
proc url_LinkedServicesCreateOrUpdate_568812(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "linkedServiceName" in path,
        "`linkedServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/linkedservices/"),
               (kind: VariableSegment, value: "linkedServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinkedServicesCreateOrUpdate_568811(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a linked service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   linkedServiceName: JString (required)
  ##                    : The linked service name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568813 = path.getOrDefault("resourceGroupName")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "resourceGroupName", valid_568813
  var valid_568814 = path.getOrDefault("factoryName")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "factoryName", valid_568814
  var valid_568815 = path.getOrDefault("linkedServiceName")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "linkedServiceName", valid_568815
  var valid_568816 = path.getOrDefault("subscriptionId")
  valid_568816 = validateParameter(valid_568816, JString, required = true,
                                 default = nil)
  if valid_568816 != nil:
    section.add "subscriptionId", valid_568816
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568817 = query.getOrDefault("api-version")
  valid_568817 = validateParameter(valid_568817, JString, required = true,
                                 default = nil)
  if valid_568817 != nil:
    section.add "api-version", valid_568817
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the linkedService entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568818 = header.getOrDefault("If-Match")
  valid_568818 = validateParameter(valid_568818, JString, required = false,
                                 default = nil)
  if valid_568818 != nil:
    section.add "If-Match", valid_568818
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   linkedService: JObject (required)
  ##                : Linked service resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568820: Call_LinkedServicesCreateOrUpdate_568810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a linked service.
  ## 
  let valid = call_568820.validator(path, query, header, formData, body)
  let scheme = call_568820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568820.url(scheme.get, call_568820.host, call_568820.base,
                         call_568820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568820, url, valid)

proc call*(call_568821: Call_LinkedServicesCreateOrUpdate_568810;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          linkedServiceName: string; subscriptionId: string; linkedService: JsonNode): Recallable =
  ## linkedServicesCreateOrUpdate
  ## Creates or updates a linked service.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   linkedServiceName: string (required)
  ##                    : The linked service name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   linkedService: JObject (required)
  ##                : Linked service resource definition.
  var path_568822 = newJObject()
  var query_568823 = newJObject()
  var body_568824 = newJObject()
  add(path_568822, "resourceGroupName", newJString(resourceGroupName))
  add(path_568822, "factoryName", newJString(factoryName))
  add(query_568823, "api-version", newJString(apiVersion))
  add(path_568822, "linkedServiceName", newJString(linkedServiceName))
  add(path_568822, "subscriptionId", newJString(subscriptionId))
  if linkedService != nil:
    body_568824 = linkedService
  result = call_568821.call(path_568822, query_568823, nil, nil, body_568824)

var linkedServicesCreateOrUpdate* = Call_LinkedServicesCreateOrUpdate_568810(
    name: "linkedServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesCreateOrUpdate_568811, base: "",
    url: url_LinkedServicesCreateOrUpdate_568812, schemes: {Scheme.Https})
type
  Call_LinkedServicesGet_568797 = ref object of OpenApiRestCall_567668
proc url_LinkedServicesGet_568799(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "linkedServiceName" in path,
        "`linkedServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/linkedservices/"),
               (kind: VariableSegment, value: "linkedServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinkedServicesGet_568798(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a linked service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   linkedServiceName: JString (required)
  ##                    : The linked service name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568800 = path.getOrDefault("resourceGroupName")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "resourceGroupName", valid_568800
  var valid_568801 = path.getOrDefault("factoryName")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "factoryName", valid_568801
  var valid_568802 = path.getOrDefault("linkedServiceName")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "linkedServiceName", valid_568802
  var valid_568803 = path.getOrDefault("subscriptionId")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "subscriptionId", valid_568803
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568804 = query.getOrDefault("api-version")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "api-version", valid_568804
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the linked service entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_568805 = header.getOrDefault("If-None-Match")
  valid_568805 = validateParameter(valid_568805, JString, required = false,
                                 default = nil)
  if valid_568805 != nil:
    section.add "If-None-Match", valid_568805
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568806: Call_LinkedServicesGet_568797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a linked service.
  ## 
  let valid = call_568806.validator(path, query, header, formData, body)
  let scheme = call_568806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568806.url(scheme.get, call_568806.host, call_568806.base,
                         call_568806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568806, url, valid)

proc call*(call_568807: Call_LinkedServicesGet_568797; resourceGroupName: string;
          factoryName: string; apiVersion: string; linkedServiceName: string;
          subscriptionId: string): Recallable =
  ## linkedServicesGet
  ## Gets a linked service.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   linkedServiceName: string (required)
  ##                    : The linked service name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568808 = newJObject()
  var query_568809 = newJObject()
  add(path_568808, "resourceGroupName", newJString(resourceGroupName))
  add(path_568808, "factoryName", newJString(factoryName))
  add(query_568809, "api-version", newJString(apiVersion))
  add(path_568808, "linkedServiceName", newJString(linkedServiceName))
  add(path_568808, "subscriptionId", newJString(subscriptionId))
  result = call_568807.call(path_568808, query_568809, nil, nil, nil)

var linkedServicesGet* = Call_LinkedServicesGet_568797(name: "linkedServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesGet_568798, base: "",
    url: url_LinkedServicesGet_568799, schemes: {Scheme.Https})
type
  Call_LinkedServicesDelete_568825 = ref object of OpenApiRestCall_567668
proc url_LinkedServicesDelete_568827(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "linkedServiceName" in path,
        "`linkedServiceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/linkedservices/"),
               (kind: VariableSegment, value: "linkedServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LinkedServicesDelete_568826(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a linked service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   linkedServiceName: JString (required)
  ##                    : The linked service name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568828 = path.getOrDefault("resourceGroupName")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "resourceGroupName", valid_568828
  var valid_568829 = path.getOrDefault("factoryName")
  valid_568829 = validateParameter(valid_568829, JString, required = true,
                                 default = nil)
  if valid_568829 != nil:
    section.add "factoryName", valid_568829
  var valid_568830 = path.getOrDefault("linkedServiceName")
  valid_568830 = validateParameter(valid_568830, JString, required = true,
                                 default = nil)
  if valid_568830 != nil:
    section.add "linkedServiceName", valid_568830
  var valid_568831 = path.getOrDefault("subscriptionId")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = nil)
  if valid_568831 != nil:
    section.add "subscriptionId", valid_568831
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568832 = query.getOrDefault("api-version")
  valid_568832 = validateParameter(valid_568832, JString, required = true,
                                 default = nil)
  if valid_568832 != nil:
    section.add "api-version", valid_568832
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568833: Call_LinkedServicesDelete_568825; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a linked service.
  ## 
  let valid = call_568833.validator(path, query, header, formData, body)
  let scheme = call_568833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568833.url(scheme.get, call_568833.host, call_568833.base,
                         call_568833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568833, url, valid)

proc call*(call_568834: Call_LinkedServicesDelete_568825;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          linkedServiceName: string; subscriptionId: string): Recallable =
  ## linkedServicesDelete
  ## Deletes a linked service.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   linkedServiceName: string (required)
  ##                    : The linked service name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568835 = newJObject()
  var query_568836 = newJObject()
  add(path_568835, "resourceGroupName", newJString(resourceGroupName))
  add(path_568835, "factoryName", newJString(factoryName))
  add(query_568836, "api-version", newJString(apiVersion))
  add(path_568835, "linkedServiceName", newJString(linkedServiceName))
  add(path_568835, "subscriptionId", newJString(subscriptionId))
  result = call_568834.call(path_568835, query_568836, nil, nil, nil)

var linkedServicesDelete* = Call_LinkedServicesDelete_568825(
    name: "linkedServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesDelete_568826, base: "",
    url: url_LinkedServicesDelete_568827, schemes: {Scheme.Https})
type
  Call_PipelineRunsGet_568837 = ref object of OpenApiRestCall_567668
proc url_PipelineRunsGet_568839(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelineruns/"),
               (kind: VariableSegment, value: "runId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelineRunsGet_568838(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a pipeline run by its run ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568840 = path.getOrDefault("resourceGroupName")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "resourceGroupName", valid_568840
  var valid_568841 = path.getOrDefault("factoryName")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "factoryName", valid_568841
  var valid_568842 = path.getOrDefault("subscriptionId")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = nil)
  if valid_568842 != nil:
    section.add "subscriptionId", valid_568842
  var valid_568843 = path.getOrDefault("runId")
  valid_568843 = validateParameter(valid_568843, JString, required = true,
                                 default = nil)
  if valid_568843 != nil:
    section.add "runId", valid_568843
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568844 = query.getOrDefault("api-version")
  valid_568844 = validateParameter(valid_568844, JString, required = true,
                                 default = nil)
  if valid_568844 != nil:
    section.add "api-version", valid_568844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568845: Call_PipelineRunsGet_568837; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a pipeline run by its run ID.
  ## 
  let valid = call_568845.validator(path, query, header, formData, body)
  let scheme = call_568845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568845.url(scheme.get, call_568845.host, call_568845.base,
                         call_568845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568845, url, valid)

proc call*(call_568846: Call_PipelineRunsGet_568837; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          runId: string): Recallable =
  ## pipelineRunsGet
  ## Get a pipeline run by its run ID.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  var path_568847 = newJObject()
  var query_568848 = newJObject()
  add(path_568847, "resourceGroupName", newJString(resourceGroupName))
  add(path_568847, "factoryName", newJString(factoryName))
  add(query_568848, "api-version", newJString(apiVersion))
  add(path_568847, "subscriptionId", newJString(subscriptionId))
  add(path_568847, "runId", newJString(runId))
  result = call_568846.call(path_568847, query_568848, nil, nil, nil)

var pipelineRunsGet* = Call_PipelineRunsGet_568837(name: "pipelineRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}",
    validator: validate_PipelineRunsGet_568838, base: "", url: url_PipelineRunsGet_568839,
    schemes: {Scheme.Https})
type
  Call_PipelineRunsCancel_568849 = ref object of OpenApiRestCall_567668
proc url_PipelineRunsCancel_568851(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelineruns/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelineRunsCancel_568850(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Cancel a pipeline run by its run ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568852 = path.getOrDefault("resourceGroupName")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = nil)
  if valid_568852 != nil:
    section.add "resourceGroupName", valid_568852
  var valid_568853 = path.getOrDefault("factoryName")
  valid_568853 = validateParameter(valid_568853, JString, required = true,
                                 default = nil)
  if valid_568853 != nil:
    section.add "factoryName", valid_568853
  var valid_568854 = path.getOrDefault("subscriptionId")
  valid_568854 = validateParameter(valid_568854, JString, required = true,
                                 default = nil)
  if valid_568854 != nil:
    section.add "subscriptionId", valid_568854
  var valid_568855 = path.getOrDefault("runId")
  valid_568855 = validateParameter(valid_568855, JString, required = true,
                                 default = nil)
  if valid_568855 != nil:
    section.add "runId", valid_568855
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   isRecursive: JBool
  ##              : If true, cancel all the Child pipelines that are triggered by the current pipeline.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568856 = query.getOrDefault("api-version")
  valid_568856 = validateParameter(valid_568856, JString, required = true,
                                 default = nil)
  if valid_568856 != nil:
    section.add "api-version", valid_568856
  var valid_568857 = query.getOrDefault("isRecursive")
  valid_568857 = validateParameter(valid_568857, JBool, required = false, default = nil)
  if valid_568857 != nil:
    section.add "isRecursive", valid_568857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568858: Call_PipelineRunsCancel_568849; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a pipeline run by its run ID.
  ## 
  let valid = call_568858.validator(path, query, header, formData, body)
  let scheme = call_568858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568858.url(scheme.get, call_568858.host, call_568858.base,
                         call_568858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568858, url, valid)

proc call*(call_568859: Call_PipelineRunsCancel_568849; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          runId: string; isRecursive: bool = false): Recallable =
  ## pipelineRunsCancel
  ## Cancel a pipeline run by its run ID.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   isRecursive: bool
  ##              : If true, cancel all the Child pipelines that are triggered by the current pipeline.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  var path_568860 = newJObject()
  var query_568861 = newJObject()
  add(path_568860, "resourceGroupName", newJString(resourceGroupName))
  add(path_568860, "factoryName", newJString(factoryName))
  add(query_568861, "api-version", newJString(apiVersion))
  add(query_568861, "isRecursive", newJBool(isRecursive))
  add(path_568860, "subscriptionId", newJString(subscriptionId))
  add(path_568860, "runId", newJString(runId))
  result = call_568859.call(path_568860, query_568861, nil, nil, nil)

var pipelineRunsCancel* = Call_PipelineRunsCancel_568849(
    name: "pipelineRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}/cancel",
    validator: validate_PipelineRunsCancel_568850, base: "",
    url: url_PipelineRunsCancel_568851, schemes: {Scheme.Https})
type
  Call_ActivityRunsQueryByPipelineRun_568862 = ref object of OpenApiRestCall_567668
proc url_ActivityRunsQueryByPipelineRun_568864(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelineruns/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/queryActivityruns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActivityRunsQueryByPipelineRun_568863(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query activity runs based on input filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568865 = path.getOrDefault("resourceGroupName")
  valid_568865 = validateParameter(valid_568865, JString, required = true,
                                 default = nil)
  if valid_568865 != nil:
    section.add "resourceGroupName", valid_568865
  var valid_568866 = path.getOrDefault("factoryName")
  valid_568866 = validateParameter(valid_568866, JString, required = true,
                                 default = nil)
  if valid_568866 != nil:
    section.add "factoryName", valid_568866
  var valid_568867 = path.getOrDefault("subscriptionId")
  valid_568867 = validateParameter(valid_568867, JString, required = true,
                                 default = nil)
  if valid_568867 != nil:
    section.add "subscriptionId", valid_568867
  var valid_568868 = path.getOrDefault("runId")
  valid_568868 = validateParameter(valid_568868, JString, required = true,
                                 default = nil)
  if valid_568868 != nil:
    section.add "runId", valid_568868
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568869 = query.getOrDefault("api-version")
  valid_568869 = validateParameter(valid_568869, JString, required = true,
                                 default = nil)
  if valid_568869 != nil:
    section.add "api-version", valid_568869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the activity runs.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568871: Call_ActivityRunsQueryByPipelineRun_568862; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query activity runs based on input filter conditions.
  ## 
  let valid = call_568871.validator(path, query, header, formData, body)
  let scheme = call_568871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568871.url(scheme.get, call_568871.host, call_568871.base,
                         call_568871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568871, url, valid)

proc call*(call_568872: Call_ActivityRunsQueryByPipelineRun_568862;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; runId: string; filterParameters: JsonNode): Recallable =
  ## activityRunsQueryByPipelineRun
  ## Query activity runs based on input filter conditions.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the activity runs.
  var path_568873 = newJObject()
  var query_568874 = newJObject()
  var body_568875 = newJObject()
  add(path_568873, "resourceGroupName", newJString(resourceGroupName))
  add(path_568873, "factoryName", newJString(factoryName))
  add(query_568874, "api-version", newJString(apiVersion))
  add(path_568873, "subscriptionId", newJString(subscriptionId))
  add(path_568873, "runId", newJString(runId))
  if filterParameters != nil:
    body_568875 = filterParameters
  result = call_568872.call(path_568873, query_568874, nil, nil, body_568875)

var activityRunsQueryByPipelineRun* = Call_ActivityRunsQueryByPipelineRun_568862(
    name: "activityRunsQueryByPipelineRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}/queryActivityruns",
    validator: validate_ActivityRunsQueryByPipelineRun_568863, base: "",
    url: url_ActivityRunsQueryByPipelineRun_568864, schemes: {Scheme.Https})
type
  Call_PipelinesListByFactory_568876 = ref object of OpenApiRestCall_567668
proc url_PipelinesListByFactory_568878(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesListByFactory_568877(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists pipelines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568879 = path.getOrDefault("resourceGroupName")
  valid_568879 = validateParameter(valid_568879, JString, required = true,
                                 default = nil)
  if valid_568879 != nil:
    section.add "resourceGroupName", valid_568879
  var valid_568880 = path.getOrDefault("factoryName")
  valid_568880 = validateParameter(valid_568880, JString, required = true,
                                 default = nil)
  if valid_568880 != nil:
    section.add "factoryName", valid_568880
  var valid_568881 = path.getOrDefault("subscriptionId")
  valid_568881 = validateParameter(valid_568881, JString, required = true,
                                 default = nil)
  if valid_568881 != nil:
    section.add "subscriptionId", valid_568881
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568882 = query.getOrDefault("api-version")
  valid_568882 = validateParameter(valid_568882, JString, required = true,
                                 default = nil)
  if valid_568882 != nil:
    section.add "api-version", valid_568882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568883: Call_PipelinesListByFactory_568876; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  let valid = call_568883.validator(path, query, header, formData, body)
  let scheme = call_568883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568883.url(scheme.get, call_568883.host, call_568883.base,
                         call_568883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568883, url, valid)

proc call*(call_568884: Call_PipelinesListByFactory_568876;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## pipelinesListByFactory
  ## Lists pipelines.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568885 = newJObject()
  var query_568886 = newJObject()
  add(path_568885, "resourceGroupName", newJString(resourceGroupName))
  add(path_568885, "factoryName", newJString(factoryName))
  add(query_568886, "api-version", newJString(apiVersion))
  add(path_568885, "subscriptionId", newJString(subscriptionId))
  result = call_568884.call(path_568885, query_568886, nil, nil, nil)

var pipelinesListByFactory* = Call_PipelinesListByFactory_568876(
    name: "pipelinesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines",
    validator: validate_PipelinesListByFactory_568877, base: "",
    url: url_PipelinesListByFactory_568878, schemes: {Scheme.Https})
type
  Call_PipelinesCreateOrUpdate_568900 = ref object of OpenApiRestCall_567668
proc url_PipelinesCreateOrUpdate_568902(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesCreateOrUpdate_568901(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568903 = path.getOrDefault("resourceGroupName")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "resourceGroupName", valid_568903
  var valid_568904 = path.getOrDefault("factoryName")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "factoryName", valid_568904
  var valid_568905 = path.getOrDefault("subscriptionId")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "subscriptionId", valid_568905
  var valid_568906 = path.getOrDefault("pipelineName")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "pipelineName", valid_568906
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568907 = query.getOrDefault("api-version")
  valid_568907 = validateParameter(valid_568907, JString, required = true,
                                 default = nil)
  if valid_568907 != nil:
    section.add "api-version", valid_568907
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the pipeline entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_568908 = header.getOrDefault("If-Match")
  valid_568908 = validateParameter(valid_568908, JString, required = false,
                                 default = nil)
  if valid_568908 != nil:
    section.add "If-Match", valid_568908
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   pipeline: JObject (required)
  ##           : Pipeline resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568910: Call_PipelinesCreateOrUpdate_568900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a pipeline.
  ## 
  let valid = call_568910.validator(path, query, header, formData, body)
  let scheme = call_568910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568910.url(scheme.get, call_568910.host, call_568910.base,
                         call_568910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568910, url, valid)

proc call*(call_568911: Call_PipelinesCreateOrUpdate_568900;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          pipeline: JsonNode; subscriptionId: string; pipelineName: string): Recallable =
  ## pipelinesCreateOrUpdate
  ## Creates or updates a pipeline.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   pipeline: JObject (required)
  ##           : Pipeline resource definition.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  var path_568912 = newJObject()
  var query_568913 = newJObject()
  var body_568914 = newJObject()
  add(path_568912, "resourceGroupName", newJString(resourceGroupName))
  add(path_568912, "factoryName", newJString(factoryName))
  add(query_568913, "api-version", newJString(apiVersion))
  if pipeline != nil:
    body_568914 = pipeline
  add(path_568912, "subscriptionId", newJString(subscriptionId))
  add(path_568912, "pipelineName", newJString(pipelineName))
  result = call_568911.call(path_568912, query_568913, nil, nil, body_568914)

var pipelinesCreateOrUpdate* = Call_PipelinesCreateOrUpdate_568900(
    name: "pipelinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesCreateOrUpdate_568901, base: "",
    url: url_PipelinesCreateOrUpdate_568902, schemes: {Scheme.Https})
type
  Call_PipelinesGet_568887 = ref object of OpenApiRestCall_567668
proc url_PipelinesGet_568889(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesGet_568888(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568890 = path.getOrDefault("resourceGroupName")
  valid_568890 = validateParameter(valid_568890, JString, required = true,
                                 default = nil)
  if valid_568890 != nil:
    section.add "resourceGroupName", valid_568890
  var valid_568891 = path.getOrDefault("factoryName")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "factoryName", valid_568891
  var valid_568892 = path.getOrDefault("subscriptionId")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "subscriptionId", valid_568892
  var valid_568893 = path.getOrDefault("pipelineName")
  valid_568893 = validateParameter(valid_568893, JString, required = true,
                                 default = nil)
  if valid_568893 != nil:
    section.add "pipelineName", valid_568893
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568894 = query.getOrDefault("api-version")
  valid_568894 = validateParameter(valid_568894, JString, required = true,
                                 default = nil)
  if valid_568894 != nil:
    section.add "api-version", valid_568894
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the pipeline entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_568895 = header.getOrDefault("If-None-Match")
  valid_568895 = validateParameter(valid_568895, JString, required = false,
                                 default = nil)
  if valid_568895 != nil:
    section.add "If-None-Match", valid_568895
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568896: Call_PipelinesGet_568887; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a pipeline.
  ## 
  let valid = call_568896.validator(path, query, header, formData, body)
  let scheme = call_568896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568896.url(scheme.get, call_568896.host, call_568896.base,
                         call_568896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568896, url, valid)

proc call*(call_568897: Call_PipelinesGet_568887; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          pipelineName: string): Recallable =
  ## pipelinesGet
  ## Gets a pipeline.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  var path_568898 = newJObject()
  var query_568899 = newJObject()
  add(path_568898, "resourceGroupName", newJString(resourceGroupName))
  add(path_568898, "factoryName", newJString(factoryName))
  add(query_568899, "api-version", newJString(apiVersion))
  add(path_568898, "subscriptionId", newJString(subscriptionId))
  add(path_568898, "pipelineName", newJString(pipelineName))
  result = call_568897.call(path_568898, query_568899, nil, nil, nil)

var pipelinesGet* = Call_PipelinesGet_568887(name: "pipelinesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesGet_568888, base: "", url: url_PipelinesGet_568889,
    schemes: {Scheme.Https})
type
  Call_PipelinesDelete_568915 = ref object of OpenApiRestCall_567668
proc url_PipelinesDelete_568917(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines/"),
               (kind: VariableSegment, value: "pipelineName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesDelete_568916(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568918 = path.getOrDefault("resourceGroupName")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "resourceGroupName", valid_568918
  var valid_568919 = path.getOrDefault("factoryName")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "factoryName", valid_568919
  var valid_568920 = path.getOrDefault("subscriptionId")
  valid_568920 = validateParameter(valid_568920, JString, required = true,
                                 default = nil)
  if valid_568920 != nil:
    section.add "subscriptionId", valid_568920
  var valid_568921 = path.getOrDefault("pipelineName")
  valid_568921 = validateParameter(valid_568921, JString, required = true,
                                 default = nil)
  if valid_568921 != nil:
    section.add "pipelineName", valid_568921
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568922 = query.getOrDefault("api-version")
  valid_568922 = validateParameter(valid_568922, JString, required = true,
                                 default = nil)
  if valid_568922 != nil:
    section.add "api-version", valid_568922
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568923: Call_PipelinesDelete_568915; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline.
  ## 
  let valid = call_568923.validator(path, query, header, formData, body)
  let scheme = call_568923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568923.url(scheme.get, call_568923.host, call_568923.base,
                         call_568923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568923, url, valid)

proc call*(call_568924: Call_PipelinesDelete_568915; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          pipelineName: string): Recallable =
  ## pipelinesDelete
  ## Deletes a pipeline.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  var path_568925 = newJObject()
  var query_568926 = newJObject()
  add(path_568925, "resourceGroupName", newJString(resourceGroupName))
  add(path_568925, "factoryName", newJString(factoryName))
  add(query_568926, "api-version", newJString(apiVersion))
  add(path_568925, "subscriptionId", newJString(subscriptionId))
  add(path_568925, "pipelineName", newJString(pipelineName))
  result = call_568924.call(path_568925, query_568926, nil, nil, nil)

var pipelinesDelete* = Call_PipelinesDelete_568915(name: "pipelinesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesDelete_568916, base: "", url: url_PipelinesDelete_568917,
    schemes: {Scheme.Https})
type
  Call_PipelinesCreateRun_568927 = ref object of OpenApiRestCall_567668
proc url_PipelinesCreateRun_568929(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "pipelineName" in path, "`pipelineName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/pipelines/"),
               (kind: VariableSegment, value: "pipelineName"),
               (kind: ConstantSegment, value: "/createRun")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelinesCreateRun_568928(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a run of a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568930 = path.getOrDefault("resourceGroupName")
  valid_568930 = validateParameter(valid_568930, JString, required = true,
                                 default = nil)
  if valid_568930 != nil:
    section.add "resourceGroupName", valid_568930
  var valid_568931 = path.getOrDefault("factoryName")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "factoryName", valid_568931
  var valid_568932 = path.getOrDefault("subscriptionId")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = nil)
  if valid_568932 != nil:
    section.add "subscriptionId", valid_568932
  var valid_568933 = path.getOrDefault("pipelineName")
  valid_568933 = validateParameter(valid_568933, JString, required = true,
                                 default = nil)
  if valid_568933 != nil:
    section.add "pipelineName", valid_568933
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   referencePipelineRunId: JString
  ##                         : The pipeline run identifier. If run ID is specified the parameters of the specified run will be used to create a new run.
  ##   startActivityName: JString
  ##                    : In recovery mode, the rerun will start from this activity. If not specified, all activities will run.
  ##   isRecovery: JBool
  ##             : Recovery mode flag. If recovery mode is set to true, the specified referenced pipeline run and the new run will be grouped under the same groupId.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568934 = query.getOrDefault("api-version")
  valid_568934 = validateParameter(valid_568934, JString, required = true,
                                 default = nil)
  if valid_568934 != nil:
    section.add "api-version", valid_568934
  var valid_568935 = query.getOrDefault("referencePipelineRunId")
  valid_568935 = validateParameter(valid_568935, JString, required = false,
                                 default = nil)
  if valid_568935 != nil:
    section.add "referencePipelineRunId", valid_568935
  var valid_568936 = query.getOrDefault("startActivityName")
  valid_568936 = validateParameter(valid_568936, JString, required = false,
                                 default = nil)
  if valid_568936 != nil:
    section.add "startActivityName", valid_568936
  var valid_568937 = query.getOrDefault("isRecovery")
  valid_568937 = validateParameter(valid_568937, JBool, required = false, default = nil)
  if valid_568937 != nil:
    section.add "isRecovery", valid_568937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters of the pipeline run. These parameters will be used only if the runId is not specified.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568939: Call_PipelinesCreateRun_568927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a run of a pipeline.
  ## 
  let valid = call_568939.validator(path, query, header, formData, body)
  let scheme = call_568939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568939.url(scheme.get, call_568939.host, call_568939.base,
                         call_568939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568939, url, valid)

proc call*(call_568940: Call_PipelinesCreateRun_568927; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          pipelineName: string; referencePipelineRunId: string = "";
          startActivityName: string = ""; isRecovery: bool = false;
          parameters: JsonNode = nil): Recallable =
  ## pipelinesCreateRun
  ## Creates a run of a pipeline.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   referencePipelineRunId: string
  ##                         : The pipeline run identifier. If run ID is specified the parameters of the specified run will be used to create a new run.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  ##   startActivityName: string
  ##                    : In recovery mode, the rerun will start from this activity. If not specified, all activities will run.
  ##   isRecovery: bool
  ##             : Recovery mode flag. If recovery mode is set to true, the specified referenced pipeline run and the new run will be grouped under the same groupId.
  ##   parameters: JObject
  ##             : Parameters of the pipeline run. These parameters will be used only if the runId is not specified.
  var path_568941 = newJObject()
  var query_568942 = newJObject()
  var body_568943 = newJObject()
  add(path_568941, "resourceGroupName", newJString(resourceGroupName))
  add(path_568941, "factoryName", newJString(factoryName))
  add(query_568942, "api-version", newJString(apiVersion))
  add(path_568941, "subscriptionId", newJString(subscriptionId))
  add(query_568942, "referencePipelineRunId", newJString(referencePipelineRunId))
  add(path_568941, "pipelineName", newJString(pipelineName))
  add(query_568942, "startActivityName", newJString(startActivityName))
  add(query_568942, "isRecovery", newJBool(isRecovery))
  if parameters != nil:
    body_568943 = parameters
  result = call_568940.call(path_568941, query_568942, nil, nil, body_568943)

var pipelinesCreateRun* = Call_PipelinesCreateRun_568927(
    name: "pipelinesCreateRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}/createRun",
    validator: validate_PipelinesCreateRun_568928, base: "",
    url: url_PipelinesCreateRun_568929, schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionQueryByFactory_568944 = ref object of OpenApiRestCall_567668
proc url_DataFlowDebugSessionQueryByFactory_568946(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/queryDataFlowDebugSessions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataFlowDebugSessionQueryByFactory_568945(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query all active data flow debug sessions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568947 = path.getOrDefault("resourceGroupName")
  valid_568947 = validateParameter(valid_568947, JString, required = true,
                                 default = nil)
  if valid_568947 != nil:
    section.add "resourceGroupName", valid_568947
  var valid_568948 = path.getOrDefault("factoryName")
  valid_568948 = validateParameter(valid_568948, JString, required = true,
                                 default = nil)
  if valid_568948 != nil:
    section.add "factoryName", valid_568948
  var valid_568949 = path.getOrDefault("subscriptionId")
  valid_568949 = validateParameter(valid_568949, JString, required = true,
                                 default = nil)
  if valid_568949 != nil:
    section.add "subscriptionId", valid_568949
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568950 = query.getOrDefault("api-version")
  valid_568950 = validateParameter(valid_568950, JString, required = true,
                                 default = nil)
  if valid_568950 != nil:
    section.add "api-version", valid_568950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568951: Call_DataFlowDebugSessionQueryByFactory_568944;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Query all active data flow debug sessions.
  ## 
  let valid = call_568951.validator(path, query, header, formData, body)
  let scheme = call_568951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568951.url(scheme.get, call_568951.host, call_568951.base,
                         call_568951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568951, url, valid)

proc call*(call_568952: Call_DataFlowDebugSessionQueryByFactory_568944;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## dataFlowDebugSessionQueryByFactory
  ## Query all active data flow debug sessions.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568953 = newJObject()
  var query_568954 = newJObject()
  add(path_568953, "resourceGroupName", newJString(resourceGroupName))
  add(path_568953, "factoryName", newJString(factoryName))
  add(query_568954, "api-version", newJString(apiVersion))
  add(path_568953, "subscriptionId", newJString(subscriptionId))
  result = call_568952.call(path_568953, query_568954, nil, nil, nil)

var dataFlowDebugSessionQueryByFactory* = Call_DataFlowDebugSessionQueryByFactory_568944(
    name: "dataFlowDebugSessionQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/queryDataFlowDebugSessions",
    validator: validate_DataFlowDebugSessionQueryByFactory_568945, base: "",
    url: url_DataFlowDebugSessionQueryByFactory_568946, schemes: {Scheme.Https})
type
  Call_PipelineRunsQueryByFactory_568955 = ref object of OpenApiRestCall_567668
proc url_PipelineRunsQueryByFactory_568957(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/queryPipelineRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelineRunsQueryByFactory_568956(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query pipeline runs in the factory based on input filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568958 = path.getOrDefault("resourceGroupName")
  valid_568958 = validateParameter(valid_568958, JString, required = true,
                                 default = nil)
  if valid_568958 != nil:
    section.add "resourceGroupName", valid_568958
  var valid_568959 = path.getOrDefault("factoryName")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = nil)
  if valid_568959 != nil:
    section.add "factoryName", valid_568959
  var valid_568960 = path.getOrDefault("subscriptionId")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = nil)
  if valid_568960 != nil:
    section.add "subscriptionId", valid_568960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568961 = query.getOrDefault("api-version")
  valid_568961 = validateParameter(valid_568961, JString, required = true,
                                 default = nil)
  if valid_568961 != nil:
    section.add "api-version", valid_568961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the pipeline run.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568963: Call_PipelineRunsQueryByFactory_568955; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query pipeline runs in the factory based on input filter conditions.
  ## 
  let valid = call_568963.validator(path, query, header, formData, body)
  let scheme = call_568963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568963.url(scheme.get, call_568963.host, call_568963.base,
                         call_568963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568963, url, valid)

proc call*(call_568964: Call_PipelineRunsQueryByFactory_568955;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; filterParameters: JsonNode): Recallable =
  ## pipelineRunsQueryByFactory
  ## Query pipeline runs in the factory based on input filter conditions.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the pipeline run.
  var path_568965 = newJObject()
  var query_568966 = newJObject()
  var body_568967 = newJObject()
  add(path_568965, "resourceGroupName", newJString(resourceGroupName))
  add(path_568965, "factoryName", newJString(factoryName))
  add(query_568966, "api-version", newJString(apiVersion))
  add(path_568965, "subscriptionId", newJString(subscriptionId))
  if filterParameters != nil:
    body_568967 = filterParameters
  result = call_568964.call(path_568965, query_568966, nil, nil, body_568967)

var pipelineRunsQueryByFactory* = Call_PipelineRunsQueryByFactory_568955(
    name: "pipelineRunsQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/queryPipelineRuns",
    validator: validate_PipelineRunsQueryByFactory_568956, base: "",
    url: url_PipelineRunsQueryByFactory_568957, schemes: {Scheme.Https})
type
  Call_TriggerRunsQueryByFactory_568968 = ref object of OpenApiRestCall_567668
proc url_TriggerRunsQueryByFactory_568970(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/queryTriggerRuns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggerRunsQueryByFactory_568969(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query trigger runs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568971 = path.getOrDefault("resourceGroupName")
  valid_568971 = validateParameter(valid_568971, JString, required = true,
                                 default = nil)
  if valid_568971 != nil:
    section.add "resourceGroupName", valid_568971
  var valid_568972 = path.getOrDefault("factoryName")
  valid_568972 = validateParameter(valid_568972, JString, required = true,
                                 default = nil)
  if valid_568972 != nil:
    section.add "factoryName", valid_568972
  var valid_568973 = path.getOrDefault("subscriptionId")
  valid_568973 = validateParameter(valid_568973, JString, required = true,
                                 default = nil)
  if valid_568973 != nil:
    section.add "subscriptionId", valid_568973
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568974 = query.getOrDefault("api-version")
  valid_568974 = validateParameter(valid_568974, JString, required = true,
                                 default = nil)
  if valid_568974 != nil:
    section.add "api-version", valid_568974
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the pipeline run.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568976: Call_TriggerRunsQueryByFactory_568968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query trigger runs.
  ## 
  let valid = call_568976.validator(path, query, header, formData, body)
  let scheme = call_568976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568976.url(scheme.get, call_568976.host, call_568976.base,
                         call_568976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568976, url, valid)

proc call*(call_568977: Call_TriggerRunsQueryByFactory_568968;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; filterParameters: JsonNode): Recallable =
  ## triggerRunsQueryByFactory
  ## Query trigger runs.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the pipeline run.
  var path_568978 = newJObject()
  var query_568979 = newJObject()
  var body_568980 = newJObject()
  add(path_568978, "resourceGroupName", newJString(resourceGroupName))
  add(path_568978, "factoryName", newJString(factoryName))
  add(query_568979, "api-version", newJString(apiVersion))
  add(path_568978, "subscriptionId", newJString(subscriptionId))
  if filterParameters != nil:
    body_568980 = filterParameters
  result = call_568977.call(path_568978, query_568979, nil, nil, body_568980)

var triggerRunsQueryByFactory* = Call_TriggerRunsQueryByFactory_568968(
    name: "triggerRunsQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/queryTriggerRuns",
    validator: validate_TriggerRunsQueryByFactory_568969, base: "",
    url: url_TriggerRunsQueryByFactory_568970, schemes: {Scheme.Https})
type
  Call_TriggersListByFactory_568981 = ref object of OpenApiRestCall_567668
proc url_TriggersListByFactory_568983(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersListByFactory_568982(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568984 = path.getOrDefault("resourceGroupName")
  valid_568984 = validateParameter(valid_568984, JString, required = true,
                                 default = nil)
  if valid_568984 != nil:
    section.add "resourceGroupName", valid_568984
  var valid_568985 = path.getOrDefault("factoryName")
  valid_568985 = validateParameter(valid_568985, JString, required = true,
                                 default = nil)
  if valid_568985 != nil:
    section.add "factoryName", valid_568985
  var valid_568986 = path.getOrDefault("subscriptionId")
  valid_568986 = validateParameter(valid_568986, JString, required = true,
                                 default = nil)
  if valid_568986 != nil:
    section.add "subscriptionId", valid_568986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568987 = query.getOrDefault("api-version")
  valid_568987 = validateParameter(valid_568987, JString, required = true,
                                 default = nil)
  if valid_568987 != nil:
    section.add "api-version", valid_568987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568988: Call_TriggersListByFactory_568981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists triggers.
  ## 
  let valid = call_568988.validator(path, query, header, formData, body)
  let scheme = call_568988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568988.url(scheme.get, call_568988.host, call_568988.base,
                         call_568988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568988, url, valid)

proc call*(call_568989: Call_TriggersListByFactory_568981;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## triggersListByFactory
  ## Lists triggers.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_568990 = newJObject()
  var query_568991 = newJObject()
  add(path_568990, "resourceGroupName", newJString(resourceGroupName))
  add(path_568990, "factoryName", newJString(factoryName))
  add(query_568991, "api-version", newJString(apiVersion))
  add(path_568990, "subscriptionId", newJString(subscriptionId))
  result = call_568989.call(path_568990, query_568991, nil, nil, nil)

var triggersListByFactory* = Call_TriggersListByFactory_568981(
    name: "triggersListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers",
    validator: validate_TriggersListByFactory_568982, base: "",
    url: url_TriggersListByFactory_568983, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_569005 = ref object of OpenApiRestCall_567668
proc url_TriggersCreateOrUpdate_569007(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersCreateOrUpdate_569006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569008 = path.getOrDefault("resourceGroupName")
  valid_569008 = validateParameter(valid_569008, JString, required = true,
                                 default = nil)
  if valid_569008 != nil:
    section.add "resourceGroupName", valid_569008
  var valid_569009 = path.getOrDefault("factoryName")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "factoryName", valid_569009
  var valid_569010 = path.getOrDefault("subscriptionId")
  valid_569010 = validateParameter(valid_569010, JString, required = true,
                                 default = nil)
  if valid_569010 != nil:
    section.add "subscriptionId", valid_569010
  var valid_569011 = path.getOrDefault("triggerName")
  valid_569011 = validateParameter(valid_569011, JString, required = true,
                                 default = nil)
  if valid_569011 != nil:
    section.add "triggerName", valid_569011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569012 = query.getOrDefault("api-version")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = nil)
  if valid_569012 != nil:
    section.add "api-version", valid_569012
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the trigger entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_569013 = header.getOrDefault("If-Match")
  valid_569013 = validateParameter(valid_569013, JString, required = false,
                                 default = nil)
  if valid_569013 != nil:
    section.add "If-Match", valid_569013
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   trigger: JObject (required)
  ##          : Trigger resource definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569015: Call_TriggersCreateOrUpdate_569005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_569015.validator(path, query, header, formData, body)
  let scheme = call_569015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569015.url(scheme.get, call_569015.host, call_569015.base,
                         call_569015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569015, url, valid)

proc call*(call_569016: Call_TriggersCreateOrUpdate_569005;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; trigger: JsonNode; triggerName: string): Recallable =
  ## triggersCreateOrUpdate
  ## Creates or updates a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   trigger: JObject (required)
  ##          : Trigger resource definition.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569017 = newJObject()
  var query_569018 = newJObject()
  var body_569019 = newJObject()
  add(path_569017, "resourceGroupName", newJString(resourceGroupName))
  add(path_569017, "factoryName", newJString(factoryName))
  add(query_569018, "api-version", newJString(apiVersion))
  add(path_569017, "subscriptionId", newJString(subscriptionId))
  if trigger != nil:
    body_569019 = trigger
  add(path_569017, "triggerName", newJString(triggerName))
  result = call_569016.call(path_569017, query_569018, nil, nil, body_569019)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_569005(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersCreateOrUpdate_569006, base: "",
    url: url_TriggersCreateOrUpdate_569007, schemes: {Scheme.Https})
type
  Call_TriggersGet_568992 = ref object of OpenApiRestCall_567668
proc url_TriggersGet_568994(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersGet_568993(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568995 = path.getOrDefault("resourceGroupName")
  valid_568995 = validateParameter(valid_568995, JString, required = true,
                                 default = nil)
  if valid_568995 != nil:
    section.add "resourceGroupName", valid_568995
  var valid_568996 = path.getOrDefault("factoryName")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "factoryName", valid_568996
  var valid_568997 = path.getOrDefault("subscriptionId")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "subscriptionId", valid_568997
  var valid_568998 = path.getOrDefault("triggerName")
  valid_568998 = validateParameter(valid_568998, JString, required = true,
                                 default = nil)
  if valid_568998 != nil:
    section.add "triggerName", valid_568998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568999 = query.getOrDefault("api-version")
  valid_568999 = validateParameter(valid_568999, JString, required = true,
                                 default = nil)
  if valid_568999 != nil:
    section.add "api-version", valid_568999
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the trigger entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_569000 = header.getOrDefault("If-None-Match")
  valid_569000 = validateParameter(valid_569000, JString, required = false,
                                 default = nil)
  if valid_569000 != nil:
    section.add "If-None-Match", valid_569000
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569001: Call_TriggersGet_568992; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a trigger.
  ## 
  let valid = call_569001.validator(path, query, header, formData, body)
  let scheme = call_569001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569001.url(scheme.get, call_569001.host, call_569001.base,
                         call_569001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569001, url, valid)

proc call*(call_569002: Call_TriggersGet_568992; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## triggersGet
  ## Gets a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569003 = newJObject()
  var query_569004 = newJObject()
  add(path_569003, "resourceGroupName", newJString(resourceGroupName))
  add(path_569003, "factoryName", newJString(factoryName))
  add(query_569004, "api-version", newJString(apiVersion))
  add(path_569003, "subscriptionId", newJString(subscriptionId))
  add(path_569003, "triggerName", newJString(triggerName))
  result = call_569002.call(path_569003, query_569004, nil, nil, nil)

var triggersGet* = Call_TriggersGet_568992(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
                                        validator: validate_TriggersGet_568993,
                                        base: "", url: url_TriggersGet_568994,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_569020 = ref object of OpenApiRestCall_567668
proc url_TriggersDelete_569022(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersDelete_569021(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569023 = path.getOrDefault("resourceGroupName")
  valid_569023 = validateParameter(valid_569023, JString, required = true,
                                 default = nil)
  if valid_569023 != nil:
    section.add "resourceGroupName", valid_569023
  var valid_569024 = path.getOrDefault("factoryName")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "factoryName", valid_569024
  var valid_569025 = path.getOrDefault("subscriptionId")
  valid_569025 = validateParameter(valid_569025, JString, required = true,
                                 default = nil)
  if valid_569025 != nil:
    section.add "subscriptionId", valid_569025
  var valid_569026 = path.getOrDefault("triggerName")
  valid_569026 = validateParameter(valid_569026, JString, required = true,
                                 default = nil)
  if valid_569026 != nil:
    section.add "triggerName", valid_569026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569027 = query.getOrDefault("api-version")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = nil)
  if valid_569027 != nil:
    section.add "api-version", valid_569027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569028: Call_TriggersDelete_569020; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a trigger.
  ## 
  let valid = call_569028.validator(path, query, header, formData, body)
  let scheme = call_569028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569028.url(scheme.get, call_569028.host, call_569028.base,
                         call_569028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569028, url, valid)

proc call*(call_569029: Call_TriggersDelete_569020; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## triggersDelete
  ## Deletes a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569030 = newJObject()
  var query_569031 = newJObject()
  add(path_569030, "resourceGroupName", newJString(resourceGroupName))
  add(path_569030, "factoryName", newJString(factoryName))
  add(query_569031, "api-version", newJString(apiVersion))
  add(path_569030, "subscriptionId", newJString(subscriptionId))
  add(path_569030, "triggerName", newJString(triggerName))
  result = call_569029.call(path_569030, query_569031, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_569020(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersDelete_569021, base: "", url: url_TriggersDelete_569022,
    schemes: {Scheme.Https})
type
  Call_TriggersGetEventSubscriptionStatus_569032 = ref object of OpenApiRestCall_567668
proc url_TriggersGetEventSubscriptionStatus_569034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/getEventSubscriptionStatus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersGetEventSubscriptionStatus_569033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a trigger's event subscription status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569035 = path.getOrDefault("resourceGroupName")
  valid_569035 = validateParameter(valid_569035, JString, required = true,
                                 default = nil)
  if valid_569035 != nil:
    section.add "resourceGroupName", valid_569035
  var valid_569036 = path.getOrDefault("factoryName")
  valid_569036 = validateParameter(valid_569036, JString, required = true,
                                 default = nil)
  if valid_569036 != nil:
    section.add "factoryName", valid_569036
  var valid_569037 = path.getOrDefault("subscriptionId")
  valid_569037 = validateParameter(valid_569037, JString, required = true,
                                 default = nil)
  if valid_569037 != nil:
    section.add "subscriptionId", valid_569037
  var valid_569038 = path.getOrDefault("triggerName")
  valid_569038 = validateParameter(valid_569038, JString, required = true,
                                 default = nil)
  if valid_569038 != nil:
    section.add "triggerName", valid_569038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569039 = query.getOrDefault("api-version")
  valid_569039 = validateParameter(valid_569039, JString, required = true,
                                 default = nil)
  if valid_569039 != nil:
    section.add "api-version", valid_569039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569040: Call_TriggersGetEventSubscriptionStatus_569032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a trigger's event subscription status.
  ## 
  let valid = call_569040.validator(path, query, header, formData, body)
  let scheme = call_569040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569040.url(scheme.get, call_569040.host, call_569040.base,
                         call_569040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569040, url, valid)

proc call*(call_569041: Call_TriggersGetEventSubscriptionStatus_569032;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; triggerName: string): Recallable =
  ## triggersGetEventSubscriptionStatus
  ## Get a trigger's event subscription status.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569042 = newJObject()
  var query_569043 = newJObject()
  add(path_569042, "resourceGroupName", newJString(resourceGroupName))
  add(path_569042, "factoryName", newJString(factoryName))
  add(query_569043, "api-version", newJString(apiVersion))
  add(path_569042, "subscriptionId", newJString(subscriptionId))
  add(path_569042, "triggerName", newJString(triggerName))
  result = call_569041.call(path_569042, query_569043, nil, nil, nil)

var triggersGetEventSubscriptionStatus* = Call_TriggersGetEventSubscriptionStatus_569032(
    name: "triggersGetEventSubscriptionStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/getEventSubscriptionStatus",
    validator: validate_TriggersGetEventSubscriptionStatus_569033, base: "",
    url: url_TriggersGetEventSubscriptionStatus_569034, schemes: {Scheme.Https})
type
  Call_RerunTriggersListByTrigger_569044 = ref object of OpenApiRestCall_567668
proc url_RerunTriggersListByTrigger_569046(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/rerunTriggers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RerunTriggersListByTrigger_569045(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists rerun triggers by an original trigger name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569047 = path.getOrDefault("resourceGroupName")
  valid_569047 = validateParameter(valid_569047, JString, required = true,
                                 default = nil)
  if valid_569047 != nil:
    section.add "resourceGroupName", valid_569047
  var valid_569048 = path.getOrDefault("factoryName")
  valid_569048 = validateParameter(valid_569048, JString, required = true,
                                 default = nil)
  if valid_569048 != nil:
    section.add "factoryName", valid_569048
  var valid_569049 = path.getOrDefault("subscriptionId")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "subscriptionId", valid_569049
  var valid_569050 = path.getOrDefault("triggerName")
  valid_569050 = validateParameter(valid_569050, JString, required = true,
                                 default = nil)
  if valid_569050 != nil:
    section.add "triggerName", valid_569050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569051 = query.getOrDefault("api-version")
  valid_569051 = validateParameter(valid_569051, JString, required = true,
                                 default = nil)
  if valid_569051 != nil:
    section.add "api-version", valid_569051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569052: Call_RerunTriggersListByTrigger_569044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists rerun triggers by an original trigger name.
  ## 
  let valid = call_569052.validator(path, query, header, formData, body)
  let scheme = call_569052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569052.url(scheme.get, call_569052.host, call_569052.base,
                         call_569052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569052, url, valid)

proc call*(call_569053: Call_RerunTriggersListByTrigger_569044;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; triggerName: string): Recallable =
  ## rerunTriggersListByTrigger
  ## Lists rerun triggers by an original trigger name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569054 = newJObject()
  var query_569055 = newJObject()
  add(path_569054, "resourceGroupName", newJString(resourceGroupName))
  add(path_569054, "factoryName", newJString(factoryName))
  add(query_569055, "api-version", newJString(apiVersion))
  add(path_569054, "subscriptionId", newJString(subscriptionId))
  add(path_569054, "triggerName", newJString(triggerName))
  result = call_569053.call(path_569054, query_569055, nil, nil, nil)

var rerunTriggersListByTrigger* = Call_RerunTriggersListByTrigger_569044(
    name: "rerunTriggersListByTrigger", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers",
    validator: validate_RerunTriggersListByTrigger_569045, base: "",
    url: url_RerunTriggersListByTrigger_569046, schemes: {Scheme.Https})
type
  Call_RerunTriggersCreate_569056 = ref object of OpenApiRestCall_567668
proc url_RerunTriggersCreate_569058(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  assert "rerunTriggerName" in path,
        "`rerunTriggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/rerunTriggers/"),
               (kind: VariableSegment, value: "rerunTriggerName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RerunTriggersCreate_569057(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a rerun trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: JString (required)
  ##                   : The rerun trigger name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569059 = path.getOrDefault("resourceGroupName")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "resourceGroupName", valid_569059
  var valid_569060 = path.getOrDefault("factoryName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "factoryName", valid_569060
  var valid_569061 = path.getOrDefault("subscriptionId")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "subscriptionId", valid_569061
  var valid_569062 = path.getOrDefault("rerunTriggerName")
  valid_569062 = validateParameter(valid_569062, JString, required = true,
                                 default = nil)
  if valid_569062 != nil:
    section.add "rerunTriggerName", valid_569062
  var valid_569063 = path.getOrDefault("triggerName")
  valid_569063 = validateParameter(valid_569063, JString, required = true,
                                 default = nil)
  if valid_569063 != nil:
    section.add "triggerName", valid_569063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569064 = query.getOrDefault("api-version")
  valid_569064 = validateParameter(valid_569064, JString, required = true,
                                 default = nil)
  if valid_569064 != nil:
    section.add "api-version", valid_569064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   rerunTumblingWindowTriggerActionParameters: JObject (required)
  ##                                             : Rerun tumbling window trigger action parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_569066: Call_RerunTriggersCreate_569056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a rerun trigger.
  ## 
  let valid = call_569066.validator(path, query, header, formData, body)
  let scheme = call_569066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569066.url(scheme.get, call_569066.host, call_569066.base,
                         call_569066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569066, url, valid)

proc call*(call_569067: Call_RerunTriggersCreate_569056; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          rerunTriggerName: string;
          rerunTumblingWindowTriggerActionParameters: JsonNode;
          triggerName: string): Recallable =
  ## rerunTriggersCreate
  ## Creates a rerun trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: string (required)
  ##                   : The rerun trigger name.
  ##   rerunTumblingWindowTriggerActionParameters: JObject (required)
  ##                                             : Rerun tumbling window trigger action parameters.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569068 = newJObject()
  var query_569069 = newJObject()
  var body_569070 = newJObject()
  add(path_569068, "resourceGroupName", newJString(resourceGroupName))
  add(path_569068, "factoryName", newJString(factoryName))
  add(query_569069, "api-version", newJString(apiVersion))
  add(path_569068, "subscriptionId", newJString(subscriptionId))
  add(path_569068, "rerunTriggerName", newJString(rerunTriggerName))
  if rerunTumblingWindowTriggerActionParameters != nil:
    body_569070 = rerunTumblingWindowTriggerActionParameters
  add(path_569068, "triggerName", newJString(triggerName))
  result = call_569067.call(path_569068, query_569069, nil, nil, body_569070)

var rerunTriggersCreate* = Call_RerunTriggersCreate_569056(
    name: "rerunTriggersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}",
    validator: validate_RerunTriggersCreate_569057, base: "",
    url: url_RerunTriggersCreate_569058, schemes: {Scheme.Https})
type
  Call_RerunTriggersCancel_569071 = ref object of OpenApiRestCall_567668
proc url_RerunTriggersCancel_569073(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  assert "rerunTriggerName" in path,
        "`rerunTriggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/rerunTriggers/"),
               (kind: VariableSegment, value: "rerunTriggerName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RerunTriggersCancel_569072(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Cancels a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: JString (required)
  ##                   : The rerun trigger name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569074 = path.getOrDefault("resourceGroupName")
  valid_569074 = validateParameter(valid_569074, JString, required = true,
                                 default = nil)
  if valid_569074 != nil:
    section.add "resourceGroupName", valid_569074
  var valid_569075 = path.getOrDefault("factoryName")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "factoryName", valid_569075
  var valid_569076 = path.getOrDefault("subscriptionId")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = nil)
  if valid_569076 != nil:
    section.add "subscriptionId", valid_569076
  var valid_569077 = path.getOrDefault("rerunTriggerName")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = nil)
  if valid_569077 != nil:
    section.add "rerunTriggerName", valid_569077
  var valid_569078 = path.getOrDefault("triggerName")
  valid_569078 = validateParameter(valid_569078, JString, required = true,
                                 default = nil)
  if valid_569078 != nil:
    section.add "triggerName", valid_569078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569079 = query.getOrDefault("api-version")
  valid_569079 = validateParameter(valid_569079, JString, required = true,
                                 default = nil)
  if valid_569079 != nil:
    section.add "api-version", valid_569079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569080: Call_RerunTriggersCancel_569071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a trigger.
  ## 
  let valid = call_569080.validator(path, query, header, formData, body)
  let scheme = call_569080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569080.url(scheme.get, call_569080.host, call_569080.base,
                         call_569080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569080, url, valid)

proc call*(call_569081: Call_RerunTriggersCancel_569071; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          rerunTriggerName: string; triggerName: string): Recallable =
  ## rerunTriggersCancel
  ## Cancels a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: string (required)
  ##                   : The rerun trigger name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569082 = newJObject()
  var query_569083 = newJObject()
  add(path_569082, "resourceGroupName", newJString(resourceGroupName))
  add(path_569082, "factoryName", newJString(factoryName))
  add(query_569083, "api-version", newJString(apiVersion))
  add(path_569082, "subscriptionId", newJString(subscriptionId))
  add(path_569082, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_569082, "triggerName", newJString(triggerName))
  result = call_569081.call(path_569082, query_569083, nil, nil, nil)

var rerunTriggersCancel* = Call_RerunTriggersCancel_569071(
    name: "rerunTriggersCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}/cancel",
    validator: validate_RerunTriggersCancel_569072, base: "",
    url: url_RerunTriggersCancel_569073, schemes: {Scheme.Https})
type
  Call_RerunTriggersStart_569084 = ref object of OpenApiRestCall_567668
proc url_RerunTriggersStart_569086(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  assert "rerunTriggerName" in path,
        "`rerunTriggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/rerunTriggers/"),
               (kind: VariableSegment, value: "rerunTriggerName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RerunTriggersStart_569085(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Starts a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: JString (required)
  ##                   : The rerun trigger name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569087 = path.getOrDefault("resourceGroupName")
  valid_569087 = validateParameter(valid_569087, JString, required = true,
                                 default = nil)
  if valid_569087 != nil:
    section.add "resourceGroupName", valid_569087
  var valid_569088 = path.getOrDefault("factoryName")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = nil)
  if valid_569088 != nil:
    section.add "factoryName", valid_569088
  var valid_569089 = path.getOrDefault("subscriptionId")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "subscriptionId", valid_569089
  var valid_569090 = path.getOrDefault("rerunTriggerName")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "rerunTriggerName", valid_569090
  var valid_569091 = path.getOrDefault("triggerName")
  valid_569091 = validateParameter(valid_569091, JString, required = true,
                                 default = nil)
  if valid_569091 != nil:
    section.add "triggerName", valid_569091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569092 = query.getOrDefault("api-version")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = nil)
  if valid_569092 != nil:
    section.add "api-version", valid_569092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569093: Call_RerunTriggersStart_569084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a trigger.
  ## 
  let valid = call_569093.validator(path, query, header, formData, body)
  let scheme = call_569093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569093.url(scheme.get, call_569093.host, call_569093.base,
                         call_569093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569093, url, valid)

proc call*(call_569094: Call_RerunTriggersStart_569084; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          rerunTriggerName: string; triggerName: string): Recallable =
  ## rerunTriggersStart
  ## Starts a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: string (required)
  ##                   : The rerun trigger name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569095 = newJObject()
  var query_569096 = newJObject()
  add(path_569095, "resourceGroupName", newJString(resourceGroupName))
  add(path_569095, "factoryName", newJString(factoryName))
  add(query_569096, "api-version", newJString(apiVersion))
  add(path_569095, "subscriptionId", newJString(subscriptionId))
  add(path_569095, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_569095, "triggerName", newJString(triggerName))
  result = call_569094.call(path_569095, query_569096, nil, nil, nil)

var rerunTriggersStart* = Call_RerunTriggersStart_569084(
    name: "rerunTriggersStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}/start",
    validator: validate_RerunTriggersStart_569085, base: "",
    url: url_RerunTriggersStart_569086, schemes: {Scheme.Https})
type
  Call_RerunTriggersStop_569097 = ref object of OpenApiRestCall_567668
proc url_RerunTriggersStop_569099(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  assert "rerunTriggerName" in path,
        "`rerunTriggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/rerunTriggers/"),
               (kind: VariableSegment, value: "rerunTriggerName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RerunTriggersStop_569098(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stops a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: JString (required)
  ##                   : The rerun trigger name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569100 = path.getOrDefault("resourceGroupName")
  valid_569100 = validateParameter(valid_569100, JString, required = true,
                                 default = nil)
  if valid_569100 != nil:
    section.add "resourceGroupName", valid_569100
  var valid_569101 = path.getOrDefault("factoryName")
  valid_569101 = validateParameter(valid_569101, JString, required = true,
                                 default = nil)
  if valid_569101 != nil:
    section.add "factoryName", valid_569101
  var valid_569102 = path.getOrDefault("subscriptionId")
  valid_569102 = validateParameter(valid_569102, JString, required = true,
                                 default = nil)
  if valid_569102 != nil:
    section.add "subscriptionId", valid_569102
  var valid_569103 = path.getOrDefault("rerunTriggerName")
  valid_569103 = validateParameter(valid_569103, JString, required = true,
                                 default = nil)
  if valid_569103 != nil:
    section.add "rerunTriggerName", valid_569103
  var valid_569104 = path.getOrDefault("triggerName")
  valid_569104 = validateParameter(valid_569104, JString, required = true,
                                 default = nil)
  if valid_569104 != nil:
    section.add "triggerName", valid_569104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569105 = query.getOrDefault("api-version")
  valid_569105 = validateParameter(valid_569105, JString, required = true,
                                 default = nil)
  if valid_569105 != nil:
    section.add "api-version", valid_569105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569106: Call_RerunTriggersStop_569097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a trigger.
  ## 
  let valid = call_569106.validator(path, query, header, formData, body)
  let scheme = call_569106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569106.url(scheme.get, call_569106.host, call_569106.base,
                         call_569106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569106, url, valid)

proc call*(call_569107: Call_RerunTriggersStop_569097; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          rerunTriggerName: string; triggerName: string): Recallable =
  ## rerunTriggersStop
  ## Stops a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: string (required)
  ##                   : The rerun trigger name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569108 = newJObject()
  var query_569109 = newJObject()
  add(path_569108, "resourceGroupName", newJString(resourceGroupName))
  add(path_569108, "factoryName", newJString(factoryName))
  add(query_569109, "api-version", newJString(apiVersion))
  add(path_569108, "subscriptionId", newJString(subscriptionId))
  add(path_569108, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_569108, "triggerName", newJString(triggerName))
  result = call_569107.call(path_569108, query_569109, nil, nil, nil)

var rerunTriggersStop* = Call_RerunTriggersStop_569097(name: "rerunTriggersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}/stop",
    validator: validate_RerunTriggersStop_569098, base: "",
    url: url_RerunTriggersStop_569099, schemes: {Scheme.Https})
type
  Call_TriggersStart_569110 = ref object of OpenApiRestCall_567668
proc url_TriggersStart_569112(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersStart_569111(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569113 = path.getOrDefault("resourceGroupName")
  valid_569113 = validateParameter(valid_569113, JString, required = true,
                                 default = nil)
  if valid_569113 != nil:
    section.add "resourceGroupName", valid_569113
  var valid_569114 = path.getOrDefault("factoryName")
  valid_569114 = validateParameter(valid_569114, JString, required = true,
                                 default = nil)
  if valid_569114 != nil:
    section.add "factoryName", valid_569114
  var valid_569115 = path.getOrDefault("subscriptionId")
  valid_569115 = validateParameter(valid_569115, JString, required = true,
                                 default = nil)
  if valid_569115 != nil:
    section.add "subscriptionId", valid_569115
  var valid_569116 = path.getOrDefault("triggerName")
  valid_569116 = validateParameter(valid_569116, JString, required = true,
                                 default = nil)
  if valid_569116 != nil:
    section.add "triggerName", valid_569116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569117 = query.getOrDefault("api-version")
  valid_569117 = validateParameter(valid_569117, JString, required = true,
                                 default = nil)
  if valid_569117 != nil:
    section.add "api-version", valid_569117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569118: Call_TriggersStart_569110; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a trigger.
  ## 
  let valid = call_569118.validator(path, query, header, formData, body)
  let scheme = call_569118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569118.url(scheme.get, call_569118.host, call_569118.base,
                         call_569118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569118, url, valid)

proc call*(call_569119: Call_TriggersStart_569110; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## triggersStart
  ## Starts a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569120 = newJObject()
  var query_569121 = newJObject()
  add(path_569120, "resourceGroupName", newJString(resourceGroupName))
  add(path_569120, "factoryName", newJString(factoryName))
  add(query_569121, "api-version", newJString(apiVersion))
  add(path_569120, "subscriptionId", newJString(subscriptionId))
  add(path_569120, "triggerName", newJString(triggerName))
  result = call_569119.call(path_569120, query_569121, nil, nil, nil)

var triggersStart* = Call_TriggersStart_569110(name: "triggersStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/start",
    validator: validate_TriggersStart_569111, base: "", url: url_TriggersStart_569112,
    schemes: {Scheme.Https})
type
  Call_TriggersStop_569122 = ref object of OpenApiRestCall_567668
proc url_TriggersStop_569124(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersStop_569123(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569125 = path.getOrDefault("resourceGroupName")
  valid_569125 = validateParameter(valid_569125, JString, required = true,
                                 default = nil)
  if valid_569125 != nil:
    section.add "resourceGroupName", valid_569125
  var valid_569126 = path.getOrDefault("factoryName")
  valid_569126 = validateParameter(valid_569126, JString, required = true,
                                 default = nil)
  if valid_569126 != nil:
    section.add "factoryName", valid_569126
  var valid_569127 = path.getOrDefault("subscriptionId")
  valid_569127 = validateParameter(valid_569127, JString, required = true,
                                 default = nil)
  if valid_569127 != nil:
    section.add "subscriptionId", valid_569127
  var valid_569128 = path.getOrDefault("triggerName")
  valid_569128 = validateParameter(valid_569128, JString, required = true,
                                 default = nil)
  if valid_569128 != nil:
    section.add "triggerName", valid_569128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569129 = query.getOrDefault("api-version")
  valid_569129 = validateParameter(valid_569129, JString, required = true,
                                 default = nil)
  if valid_569129 != nil:
    section.add "api-version", valid_569129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569130: Call_TriggersStop_569122; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a trigger.
  ## 
  let valid = call_569130.validator(path, query, header, formData, body)
  let scheme = call_569130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569130.url(scheme.get, call_569130.host, call_569130.base,
                         call_569130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569130, url, valid)

proc call*(call_569131: Call_TriggersStop_569122; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          triggerName: string): Recallable =
  ## triggersStop
  ## Stops a trigger.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569132 = newJObject()
  var query_569133 = newJObject()
  add(path_569132, "resourceGroupName", newJString(resourceGroupName))
  add(path_569132, "factoryName", newJString(factoryName))
  add(query_569133, "api-version", newJString(apiVersion))
  add(path_569132, "subscriptionId", newJString(subscriptionId))
  add(path_569132, "triggerName", newJString(triggerName))
  result = call_569131.call(path_569132, query_569133, nil, nil, nil)

var triggersStop* = Call_TriggersStop_569122(name: "triggersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/stop",
    validator: validate_TriggersStop_569123, base: "", url: url_TriggersStop_569124,
    schemes: {Scheme.Https})
type
  Call_TriggersSubscribeToEvents_569134 = ref object of OpenApiRestCall_567668
proc url_TriggersSubscribeToEvents_569136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/subscribeToEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersSubscribeToEvents_569135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Subscribe event trigger to events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569137 = path.getOrDefault("resourceGroupName")
  valid_569137 = validateParameter(valid_569137, JString, required = true,
                                 default = nil)
  if valid_569137 != nil:
    section.add "resourceGroupName", valid_569137
  var valid_569138 = path.getOrDefault("factoryName")
  valid_569138 = validateParameter(valid_569138, JString, required = true,
                                 default = nil)
  if valid_569138 != nil:
    section.add "factoryName", valid_569138
  var valid_569139 = path.getOrDefault("subscriptionId")
  valid_569139 = validateParameter(valid_569139, JString, required = true,
                                 default = nil)
  if valid_569139 != nil:
    section.add "subscriptionId", valid_569139
  var valid_569140 = path.getOrDefault("triggerName")
  valid_569140 = validateParameter(valid_569140, JString, required = true,
                                 default = nil)
  if valid_569140 != nil:
    section.add "triggerName", valid_569140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569141 = query.getOrDefault("api-version")
  valid_569141 = validateParameter(valid_569141, JString, required = true,
                                 default = nil)
  if valid_569141 != nil:
    section.add "api-version", valid_569141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569142: Call_TriggersSubscribeToEvents_569134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe event trigger to events.
  ## 
  let valid = call_569142.validator(path, query, header, formData, body)
  let scheme = call_569142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569142.url(scheme.get, call_569142.host, call_569142.base,
                         call_569142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569142, url, valid)

proc call*(call_569143: Call_TriggersSubscribeToEvents_569134;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; triggerName: string): Recallable =
  ## triggersSubscribeToEvents
  ## Subscribe event trigger to events.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569144 = newJObject()
  var query_569145 = newJObject()
  add(path_569144, "resourceGroupName", newJString(resourceGroupName))
  add(path_569144, "factoryName", newJString(factoryName))
  add(query_569145, "api-version", newJString(apiVersion))
  add(path_569144, "subscriptionId", newJString(subscriptionId))
  add(path_569144, "triggerName", newJString(triggerName))
  result = call_569143.call(path_569144, query_569145, nil, nil, nil)

var triggersSubscribeToEvents* = Call_TriggersSubscribeToEvents_569134(
    name: "triggersSubscribeToEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/subscribeToEvents",
    validator: validate_TriggersSubscribeToEvents_569135, base: "",
    url: url_TriggersSubscribeToEvents_569136, schemes: {Scheme.Https})
type
  Call_TriggerRunsRerun_569146 = ref object of OpenApiRestCall_567668
proc url_TriggerRunsRerun_569148(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  assert "runId" in path, "`runId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/triggerRuns/"),
               (kind: VariableSegment, value: "runId"),
               (kind: ConstantSegment, value: "/rerun")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggerRunsRerun_569147(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Rerun single trigger instance by runId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569149 = path.getOrDefault("resourceGroupName")
  valid_569149 = validateParameter(valid_569149, JString, required = true,
                                 default = nil)
  if valid_569149 != nil:
    section.add "resourceGroupName", valid_569149
  var valid_569150 = path.getOrDefault("factoryName")
  valid_569150 = validateParameter(valid_569150, JString, required = true,
                                 default = nil)
  if valid_569150 != nil:
    section.add "factoryName", valid_569150
  var valid_569151 = path.getOrDefault("subscriptionId")
  valid_569151 = validateParameter(valid_569151, JString, required = true,
                                 default = nil)
  if valid_569151 != nil:
    section.add "subscriptionId", valid_569151
  var valid_569152 = path.getOrDefault("runId")
  valid_569152 = validateParameter(valid_569152, JString, required = true,
                                 default = nil)
  if valid_569152 != nil:
    section.add "runId", valid_569152
  var valid_569153 = path.getOrDefault("triggerName")
  valid_569153 = validateParameter(valid_569153, JString, required = true,
                                 default = nil)
  if valid_569153 != nil:
    section.add "triggerName", valid_569153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569154 = query.getOrDefault("api-version")
  valid_569154 = validateParameter(valid_569154, JString, required = true,
                                 default = nil)
  if valid_569154 != nil:
    section.add "api-version", valid_569154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569155: Call_TriggerRunsRerun_569146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rerun single trigger instance by runId.
  ## 
  let valid = call_569155.validator(path, query, header, formData, body)
  let scheme = call_569155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569155.url(scheme.get, call_569155.host, call_569155.base,
                         call_569155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569155, url, valid)

proc call*(call_569156: Call_TriggerRunsRerun_569146; resourceGroupName: string;
          factoryName: string; apiVersion: string; subscriptionId: string;
          runId: string; triggerName: string): Recallable =
  ## triggerRunsRerun
  ## Rerun single trigger instance by runId.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569157 = newJObject()
  var query_569158 = newJObject()
  add(path_569157, "resourceGroupName", newJString(resourceGroupName))
  add(path_569157, "factoryName", newJString(factoryName))
  add(query_569158, "api-version", newJString(apiVersion))
  add(path_569157, "subscriptionId", newJString(subscriptionId))
  add(path_569157, "runId", newJString(runId))
  add(path_569157, "triggerName", newJString(triggerName))
  result = call_569156.call(path_569157, query_569158, nil, nil, nil)

var triggerRunsRerun* = Call_TriggerRunsRerun_569146(name: "triggerRunsRerun",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/triggerRuns/{runId}/rerun",
    validator: validate_TriggerRunsRerun_569147, base: "",
    url: url_TriggerRunsRerun_569148, schemes: {Scheme.Https})
type
  Call_TriggersUnsubscribeFromEvents_569159 = ref object of OpenApiRestCall_567668
proc url_TriggersUnsubscribeFromEvents_569161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "factoryName" in path, "`factoryName` is a required path parameter"
  assert "triggerName" in path, "`triggerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.DataFactory/factories/"),
               (kind: VariableSegment, value: "factoryName"),
               (kind: ConstantSegment, value: "/triggers/"),
               (kind: VariableSegment, value: "triggerName"),
               (kind: ConstantSegment, value: "/unsubscribeFromEvents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersUnsubscribeFromEvents_569160(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unsubscribe event trigger from events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569162 = path.getOrDefault("resourceGroupName")
  valid_569162 = validateParameter(valid_569162, JString, required = true,
                                 default = nil)
  if valid_569162 != nil:
    section.add "resourceGroupName", valid_569162
  var valid_569163 = path.getOrDefault("factoryName")
  valid_569163 = validateParameter(valid_569163, JString, required = true,
                                 default = nil)
  if valid_569163 != nil:
    section.add "factoryName", valid_569163
  var valid_569164 = path.getOrDefault("subscriptionId")
  valid_569164 = validateParameter(valid_569164, JString, required = true,
                                 default = nil)
  if valid_569164 != nil:
    section.add "subscriptionId", valid_569164
  var valid_569165 = path.getOrDefault("triggerName")
  valid_569165 = validateParameter(valid_569165, JString, required = true,
                                 default = nil)
  if valid_569165 != nil:
    section.add "triggerName", valid_569165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569166 = query.getOrDefault("api-version")
  valid_569166 = validateParameter(valid_569166, JString, required = true,
                                 default = nil)
  if valid_569166 != nil:
    section.add "api-version", valid_569166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569167: Call_TriggersUnsubscribeFromEvents_569159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unsubscribe event trigger from events.
  ## 
  let valid = call_569167.validator(path, query, header, formData, body)
  let scheme = call_569167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569167.url(scheme.get, call_569167.host, call_569167.base,
                         call_569167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569167, url, valid)

proc call*(call_569168: Call_TriggersUnsubscribeFromEvents_569159;
          resourceGroupName: string; factoryName: string; apiVersion: string;
          subscriptionId: string; triggerName: string): Recallable =
  ## triggersUnsubscribeFromEvents
  ## Unsubscribe event trigger from events.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   triggerName: string (required)
  ##              : The trigger name.
  var path_569169 = newJObject()
  var query_569170 = newJObject()
  add(path_569169, "resourceGroupName", newJString(resourceGroupName))
  add(path_569169, "factoryName", newJString(factoryName))
  add(query_569170, "api-version", newJString(apiVersion))
  add(path_569169, "subscriptionId", newJString(subscriptionId))
  add(path_569169, "triggerName", newJString(triggerName))
  result = call_569168.call(path_569169, query_569170, nil, nil, nil)

var triggersUnsubscribeFromEvents* = Call_TriggersUnsubscribeFromEvents_569159(
    name: "triggersUnsubscribeFromEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/unsubscribeFromEvents",
    validator: validate_TriggersUnsubscribeFromEvents_569160, base: "",
    url: url_TriggersUnsubscribeFromEvents_569161, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
