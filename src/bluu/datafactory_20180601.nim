
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563566 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563566](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563566): Option[Scheme] {.used.} =
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
  macServiceName = "datafactory"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563788 = ref object of OpenApiRestCall_563566
proc url_OperationsList_563790(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563789(path: JsonNode; query: JsonNode;
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
  var valid_563951 = query.getOrDefault("api-version")
  valid_563951 = validateParameter(valid_563951, JString, required = true,
                                 default = nil)
  if valid_563951 != nil:
    section.add "api-version", valid_563951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563974: Call_OperationsList_563788; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Azure Data Factory API operations.
  ## 
  let valid = call_563974.validator(path, query, header, formData, body)
  let scheme = call_563974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563974.url(scheme.get, call_563974.host, call_563974.base,
                         call_563974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563974, url, valid)

proc call*(call_564045: Call_OperationsList_563788; apiVersion: string): Recallable =
  ## operationsList
  ## Lists the available Azure Data Factory API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_564046 = newJObject()
  add(query_564046, "api-version", newJString(apiVersion))
  result = call_564045.call(nil, query_564046, nil, nil, nil)

var operationsList* = Call_OperationsList_563788(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataFactory/operations",
    validator: validate_OperationsList_563789, base: "", url: url_OperationsList_563790,
    schemes: {Scheme.Https})
type
  Call_FactoriesList_564086 = ref object of OpenApiRestCall_563566
proc url_FactoriesList_564088(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesList_564087(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564103 = path.getOrDefault("subscriptionId")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "subscriptionId", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_FactoriesList_564086; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories under the specified subscription.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_FactoriesList_564086; apiVersion: string;
          subscriptionId: string): Recallable =
  ## factoriesList
  ## Lists factories under the specified subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var factoriesList* = Call_FactoriesList_564086(name: "factoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesList_564087, base: "", url: url_FactoriesList_564088,
    schemes: {Scheme.Https})
type
  Call_FactoriesConfigureFactoryRepo_564109 = ref object of OpenApiRestCall_563566
proc url_FactoriesConfigureFactoryRepo_564111(protocol: Scheme; host: string;
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

proc validate_FactoriesConfigureFactoryRepo_564110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a factory's repo information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   locationId: JString (required)
  ##             : The location identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  var valid_564130 = path.getOrDefault("locationId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "locationId", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
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
  ## parameters in `body` object:
  ##   factoryRepoUpdate: JObject (required)
  ##                    : Update factory repo request definition.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_FactoriesConfigureFactoryRepo_564109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory's repo information.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_FactoriesConfigureFactoryRepo_564109;
          apiVersion: string; subscriptionId: string; locationId: string;
          factoryRepoUpdate: JsonNode): Recallable =
  ## factoriesConfigureFactoryRepo
  ## Updates a factory's repo information.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   locationId: string (required)
  ##             : The location identifier.
  ##   factoryRepoUpdate: JObject (required)
  ##                    : Update factory repo request definition.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  var body_564137 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "locationId", newJString(locationId))
  if factoryRepoUpdate != nil:
    body_564137 = factoryRepoUpdate
  result = call_564134.call(path_564135, query_564136, nil, nil, body_564137)

var factoriesConfigureFactoryRepo* = Call_FactoriesConfigureFactoryRepo_564109(
    name: "factoriesConfigureFactoryRepo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/locations/{locationId}/configureFactoryRepo",
    validator: validate_FactoriesConfigureFactoryRepo_564110, base: "",
    url: url_FactoriesConfigureFactoryRepo_564111, schemes: {Scheme.Https})
type
  Call_ExposureControlGetFeatureValue_564138 = ref object of OpenApiRestCall_563566
proc url_ExposureControlGetFeatureValue_564140(protocol: Scheme; host: string;
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

proc validate_ExposureControlGetFeatureValue_564139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get exposure control feature for specific location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   locationId: JString (required)
  ##             : The location identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("locationId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "locationId", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
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

proc call*(call_564145: Call_ExposureControlGetFeatureValue_564138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get exposure control feature for specific location.
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_ExposureControlGetFeatureValue_564138;
          apiVersion: string; exposureControlRequest: JsonNode;
          subscriptionId: string; locationId: string): Recallable =
  ## exposureControlGetFeatureValue
  ## Get exposure control feature for specific location.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   exposureControlRequest: JObject (required)
  ##                         : The exposure control request.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   locationId: string (required)
  ##             : The location identifier.
  var path_564147 = newJObject()
  var query_564148 = newJObject()
  var body_564149 = newJObject()
  add(query_564148, "api-version", newJString(apiVersion))
  if exposureControlRequest != nil:
    body_564149 = exposureControlRequest
  add(path_564147, "subscriptionId", newJString(subscriptionId))
  add(path_564147, "locationId", newJString(locationId))
  result = call_564146.call(path_564147, query_564148, nil, nil, body_564149)

var exposureControlGetFeatureValue* = Call_ExposureControlGetFeatureValue_564138(
    name: "exposureControlGetFeatureValue", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/locations/{locationId}/getFeatureValue",
    validator: validate_ExposureControlGetFeatureValue_564139, base: "",
    url: url_ExposureControlGetFeatureValue_564140, schemes: {Scheme.Https})
type
  Call_FactoriesListByResourceGroup_564150 = ref object of OpenApiRestCall_563566
proc url_FactoriesListByResourceGroup_564152(protocol: Scheme; host: string;
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

proc validate_FactoriesListByResourceGroup_564151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists factories.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564153 = path.getOrDefault("subscriptionId")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "subscriptionId", valid_564153
  var valid_564154 = path.getOrDefault("resourceGroupName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "resourceGroupName", valid_564154
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564155 = query.getOrDefault("api-version")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "api-version", valid_564155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564156: Call_FactoriesListByResourceGroup_564150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories.
  ## 
  let valid = call_564156.validator(path, query, header, formData, body)
  let scheme = call_564156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564156.url(scheme.get, call_564156.host, call_564156.base,
                         call_564156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564156, url, valid)

proc call*(call_564157: Call_FactoriesListByResourceGroup_564150;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## factoriesListByResourceGroup
  ## Lists factories.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564158 = newJObject()
  var query_564159 = newJObject()
  add(query_564159, "api-version", newJString(apiVersion))
  add(path_564158, "subscriptionId", newJString(subscriptionId))
  add(path_564158, "resourceGroupName", newJString(resourceGroupName))
  result = call_564157.call(path_564158, query_564159, nil, nil, nil)

var factoriesListByResourceGroup* = Call_FactoriesListByResourceGroup_564150(
    name: "factoriesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesListByResourceGroup_564151, base: "",
    url: url_FactoriesListByResourceGroup_564152, schemes: {Scheme.Https})
type
  Call_FactoriesCreateOrUpdate_564172 = ref object of OpenApiRestCall_563566
proc url_FactoriesCreateOrUpdate_564174(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesCreateOrUpdate_564173(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
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
  var valid_564177 = path.getOrDefault("factoryName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "factoryName", valid_564177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564178 = query.getOrDefault("api-version")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "api-version", valid_564178
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the factory entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564179 = header.getOrDefault("If-Match")
  valid_564179 = validateParameter(valid_564179, JString, required = false,
                                 default = nil)
  if valid_564179 != nil:
    section.add "If-Match", valid_564179
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

proc call*(call_564181: Call_FactoriesCreateOrUpdate_564172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a factory.
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_FactoriesCreateOrUpdate_564172; apiVersion: string;
          subscriptionId: string; factory: JsonNode; resourceGroupName: string;
          factoryName: string): Recallable =
  ## factoriesCreateOrUpdate
  ## Creates or updates a factory.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   factory: JObject (required)
  ##          : Factory resource definition.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564183 = newJObject()
  var query_564184 = newJObject()
  var body_564185 = newJObject()
  add(query_564184, "api-version", newJString(apiVersion))
  add(path_564183, "subscriptionId", newJString(subscriptionId))
  if factory != nil:
    body_564185 = factory
  add(path_564183, "resourceGroupName", newJString(resourceGroupName))
  add(path_564183, "factoryName", newJString(factoryName))
  result = call_564182.call(path_564183, query_564184, nil, nil, body_564185)

var factoriesCreateOrUpdate* = Call_FactoriesCreateOrUpdate_564172(
    name: "factoriesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesCreateOrUpdate_564173, base: "",
    url: url_FactoriesCreateOrUpdate_564174, schemes: {Scheme.Https})
type
  Call_FactoriesGet_564160 = ref object of OpenApiRestCall_563566
proc url_FactoriesGet_564162(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesGet_564161(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  var valid_564164 = path.getOrDefault("resourceGroupName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "resourceGroupName", valid_564164
  var valid_564165 = path.getOrDefault("factoryName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "factoryName", valid_564165
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564166 = query.getOrDefault("api-version")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "api-version", valid_564166
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the factory entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_564167 = header.getOrDefault("If-None-Match")
  valid_564167 = validateParameter(valid_564167, JString, required = false,
                                 default = nil)
  if valid_564167 != nil:
    section.add "If-None-Match", valid_564167
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564168: Call_FactoriesGet_564160; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a factory.
  ## 
  let valid = call_564168.validator(path, query, header, formData, body)
  let scheme = call_564168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564168.url(scheme.get, call_564168.host, call_564168.base,
                         call_564168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564168, url, valid)

proc call*(call_564169: Call_FactoriesGet_564160; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## factoriesGet
  ## Gets a factory.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564170 = newJObject()
  var query_564171 = newJObject()
  add(query_564171, "api-version", newJString(apiVersion))
  add(path_564170, "subscriptionId", newJString(subscriptionId))
  add(path_564170, "resourceGroupName", newJString(resourceGroupName))
  add(path_564170, "factoryName", newJString(factoryName))
  result = call_564169.call(path_564170, query_564171, nil, nil, nil)

var factoriesGet* = Call_FactoriesGet_564160(name: "factoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesGet_564161, base: "", url: url_FactoriesGet_564162,
    schemes: {Scheme.Https})
type
  Call_FactoriesUpdate_564197 = ref object of OpenApiRestCall_563566
proc url_FactoriesUpdate_564199(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesUpdate_564198(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564200 = path.getOrDefault("subscriptionId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "subscriptionId", valid_564200
  var valid_564201 = path.getOrDefault("resourceGroupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceGroupName", valid_564201
  var valid_564202 = path.getOrDefault("factoryName")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "factoryName", valid_564202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564203 = query.getOrDefault("api-version")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "api-version", valid_564203
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

proc call*(call_564205: Call_FactoriesUpdate_564197; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory.
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_FactoriesUpdate_564197; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          factoryUpdateParameters: JsonNode; factoryName: string): Recallable =
  ## factoriesUpdate
  ## Updates a factory.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryUpdateParameters: JObject (required)
  ##                          : The parameters for updating a factory.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  var body_564209 = newJObject()
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "resourceGroupName", newJString(resourceGroupName))
  if factoryUpdateParameters != nil:
    body_564209 = factoryUpdateParameters
  add(path_564207, "factoryName", newJString(factoryName))
  result = call_564206.call(path_564207, query_564208, nil, nil, body_564209)

var factoriesUpdate* = Call_FactoriesUpdate_564197(name: "factoriesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesUpdate_564198, base: "", url: url_FactoriesUpdate_564199,
    schemes: {Scheme.Https})
type
  Call_FactoriesDelete_564186 = ref object of OpenApiRestCall_563566
proc url_FactoriesDelete_564188(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesDelete_564187(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564189 = path.getOrDefault("subscriptionId")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "subscriptionId", valid_564189
  var valid_564190 = path.getOrDefault("resourceGroupName")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "resourceGroupName", valid_564190
  var valid_564191 = path.getOrDefault("factoryName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "factoryName", valid_564191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564192 = query.getOrDefault("api-version")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "api-version", valid_564192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564193: Call_FactoriesDelete_564186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a factory.
  ## 
  let valid = call_564193.validator(path, query, header, formData, body)
  let scheme = call_564193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564193.url(scheme.get, call_564193.host, call_564193.base,
                         call_564193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564193, url, valid)

proc call*(call_564194: Call_FactoriesDelete_564186; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## factoriesDelete
  ## Deletes a factory.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564195 = newJObject()
  var query_564196 = newJObject()
  add(query_564196, "api-version", newJString(apiVersion))
  add(path_564195, "subscriptionId", newJString(subscriptionId))
  add(path_564195, "resourceGroupName", newJString(resourceGroupName))
  add(path_564195, "factoryName", newJString(factoryName))
  result = call_564194.call(path_564195, query_564196, nil, nil, nil)

var factoriesDelete* = Call_FactoriesDelete_564186(name: "factoriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesDelete_564187, base: "", url: url_FactoriesDelete_564188,
    schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionAddDataFlow_564210 = ref object of OpenApiRestCall_563566
proc url_DataFlowDebugSessionAddDataFlow_564212(protocol: Scheme; host: string;
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

proc validate_DataFlowDebugSessionAddDataFlow_564211(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a data flow into debug session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564213 = path.getOrDefault("subscriptionId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "subscriptionId", valid_564213
  var valid_564214 = path.getOrDefault("resourceGroupName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "resourceGroupName", valid_564214
  var valid_564215 = path.getOrDefault("factoryName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "factoryName", valid_564215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564216 = query.getOrDefault("api-version")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "api-version", valid_564216
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

proc call*(call_564218: Call_DataFlowDebugSessionAddDataFlow_564210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Add a data flow into debug session.
  ## 
  let valid = call_564218.validator(path, query, header, formData, body)
  let scheme = call_564218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564218.url(scheme.get, call_564218.host, call_564218.base,
                         call_564218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564218, url, valid)

proc call*(call_564219: Call_DataFlowDebugSessionAddDataFlow_564210;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string; request: JsonNode): Recallable =
  ## dataFlowDebugSessionAddDataFlow
  ## Add a data flow into debug session.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   request: JObject (required)
  ##          : Data flow debug session definition with debug content.
  var path_564220 = newJObject()
  var query_564221 = newJObject()
  var body_564222 = newJObject()
  add(query_564221, "api-version", newJString(apiVersion))
  add(path_564220, "subscriptionId", newJString(subscriptionId))
  add(path_564220, "resourceGroupName", newJString(resourceGroupName))
  add(path_564220, "factoryName", newJString(factoryName))
  if request != nil:
    body_564222 = request
  result = call_564219.call(path_564220, query_564221, nil, nil, body_564222)

var dataFlowDebugSessionAddDataFlow* = Call_DataFlowDebugSessionAddDataFlow_564210(
    name: "dataFlowDebugSessionAddDataFlow", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/addDataFlowToDebugSession",
    validator: validate_DataFlowDebugSessionAddDataFlow_564211, base: "",
    url: url_DataFlowDebugSessionAddDataFlow_564212, schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionCreate_564223 = ref object of OpenApiRestCall_563566
proc url_DataFlowDebugSessionCreate_564225(protocol: Scheme; host: string;
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

proc validate_DataFlowDebugSessionCreate_564224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a data flow debug session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564226 = path.getOrDefault("subscriptionId")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "subscriptionId", valid_564226
  var valid_564227 = path.getOrDefault("resourceGroupName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceGroupName", valid_564227
  var valid_564228 = path.getOrDefault("factoryName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "factoryName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
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

proc call*(call_564231: Call_DataFlowDebugSessionCreate_564223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a data flow debug session.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_DataFlowDebugSessionCreate_564223; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string;
          request: JsonNode): Recallable =
  ## dataFlowDebugSessionCreate
  ## Creates a data flow debug session.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   request: JObject (required)
  ##          : Data flow debug session definition
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  var body_564235 = newJObject()
  add(query_564234, "api-version", newJString(apiVersion))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  add(path_564233, "factoryName", newJString(factoryName))
  if request != nil:
    body_564235 = request
  result = call_564232.call(path_564233, query_564234, nil, nil, body_564235)

var dataFlowDebugSessionCreate* = Call_DataFlowDebugSessionCreate_564223(
    name: "dataFlowDebugSessionCreate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/createDataFlowDebugSession",
    validator: validate_DataFlowDebugSessionCreate_564224, base: "",
    url: url_DataFlowDebugSessionCreate_564225, schemes: {Scheme.Https})
type
  Call_DataFlowsListByFactory_564236 = ref object of OpenApiRestCall_563566
proc url_DataFlowsListByFactory_564238(protocol: Scheme; host: string; base: string;
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

proc validate_DataFlowsListByFactory_564237(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists data flows.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("resourceGroupName")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "resourceGroupName", valid_564240
  var valid_564241 = path.getOrDefault("factoryName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "factoryName", valid_564241
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564242 = query.getOrDefault("api-version")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "api-version", valid_564242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564243: Call_DataFlowsListByFactory_564236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists data flows.
  ## 
  let valid = call_564243.validator(path, query, header, formData, body)
  let scheme = call_564243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564243.url(scheme.get, call_564243.host, call_564243.base,
                         call_564243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564243, url, valid)

proc call*(call_564244: Call_DataFlowsListByFactory_564236; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## dataFlowsListByFactory
  ## Lists data flows.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564245 = newJObject()
  var query_564246 = newJObject()
  add(query_564246, "api-version", newJString(apiVersion))
  add(path_564245, "subscriptionId", newJString(subscriptionId))
  add(path_564245, "resourceGroupName", newJString(resourceGroupName))
  add(path_564245, "factoryName", newJString(factoryName))
  result = call_564244.call(path_564245, query_564246, nil, nil, nil)

var dataFlowsListByFactory* = Call_DataFlowsListByFactory_564236(
    name: "dataFlowsListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/dataflows",
    validator: validate_DataFlowsListByFactory_564237, base: "",
    url: url_DataFlowsListByFactory_564238, schemes: {Scheme.Https})
type
  Call_DataFlowsCreateOrUpdate_564260 = ref object of OpenApiRestCall_563566
proc url_DataFlowsCreateOrUpdate_564262(protocol: Scheme; host: string; base: string;
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

proc validate_DataFlowsCreateOrUpdate_564261(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a data flow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: JString (required)
  ##               : The data flow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564263 = path.getOrDefault("subscriptionId")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "subscriptionId", valid_564263
  var valid_564264 = path.getOrDefault("dataFlowName")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "dataFlowName", valid_564264
  var valid_564265 = path.getOrDefault("resourceGroupName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "resourceGroupName", valid_564265
  var valid_564266 = path.getOrDefault("factoryName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "factoryName", valid_564266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564267 = query.getOrDefault("api-version")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "api-version", valid_564267
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the data flow entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564268 = header.getOrDefault("If-Match")
  valid_564268 = validateParameter(valid_564268, JString, required = false,
                                 default = nil)
  if valid_564268 != nil:
    section.add "If-Match", valid_564268
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

proc call*(call_564270: Call_DataFlowsCreateOrUpdate_564260; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a data flow.
  ## 
  let valid = call_564270.validator(path, query, header, formData, body)
  let scheme = call_564270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564270.url(scheme.get, call_564270.host, call_564270.base,
                         call_564270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564270, url, valid)

proc call*(call_564271: Call_DataFlowsCreateOrUpdate_564260; apiVersion: string;
          subscriptionId: string; dataFlow: JsonNode; dataFlowName: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## dataFlowsCreateOrUpdate
  ## Creates or updates a data flow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   dataFlow: JObject (required)
  ##           : Data flow resource definition.
  ##   dataFlowName: string (required)
  ##               : The data flow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564272 = newJObject()
  var query_564273 = newJObject()
  var body_564274 = newJObject()
  add(query_564273, "api-version", newJString(apiVersion))
  add(path_564272, "subscriptionId", newJString(subscriptionId))
  if dataFlow != nil:
    body_564274 = dataFlow
  add(path_564272, "dataFlowName", newJString(dataFlowName))
  add(path_564272, "resourceGroupName", newJString(resourceGroupName))
  add(path_564272, "factoryName", newJString(factoryName))
  result = call_564271.call(path_564272, query_564273, nil, nil, body_564274)

var dataFlowsCreateOrUpdate* = Call_DataFlowsCreateOrUpdate_564260(
    name: "dataFlowsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/dataflows/{dataFlowName}",
    validator: validate_DataFlowsCreateOrUpdate_564261, base: "",
    url: url_DataFlowsCreateOrUpdate_564262, schemes: {Scheme.Https})
type
  Call_DataFlowsGet_564247 = ref object of OpenApiRestCall_563566
proc url_DataFlowsGet_564249(protocol: Scheme; host: string; base: string;
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

proc validate_DataFlowsGet_564248(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a data flow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: JString (required)
  ##               : The data flow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564250 = path.getOrDefault("subscriptionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "subscriptionId", valid_564250
  var valid_564251 = path.getOrDefault("dataFlowName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "dataFlowName", valid_564251
  var valid_564252 = path.getOrDefault("resourceGroupName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "resourceGroupName", valid_564252
  var valid_564253 = path.getOrDefault("factoryName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "factoryName", valid_564253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564254 = query.getOrDefault("api-version")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "api-version", valid_564254
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the data flow entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_564255 = header.getOrDefault("If-None-Match")
  valid_564255 = validateParameter(valid_564255, JString, required = false,
                                 default = nil)
  if valid_564255 != nil:
    section.add "If-None-Match", valid_564255
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564256: Call_DataFlowsGet_564247; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a data flow.
  ## 
  let valid = call_564256.validator(path, query, header, formData, body)
  let scheme = call_564256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564256.url(scheme.get, call_564256.host, call_564256.base,
                         call_564256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564256, url, valid)

proc call*(call_564257: Call_DataFlowsGet_564247; apiVersion: string;
          subscriptionId: string; dataFlowName: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## dataFlowsGet
  ## Gets a data flow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: string (required)
  ##               : The data flow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564258 = newJObject()
  var query_564259 = newJObject()
  add(query_564259, "api-version", newJString(apiVersion))
  add(path_564258, "subscriptionId", newJString(subscriptionId))
  add(path_564258, "dataFlowName", newJString(dataFlowName))
  add(path_564258, "resourceGroupName", newJString(resourceGroupName))
  add(path_564258, "factoryName", newJString(factoryName))
  result = call_564257.call(path_564258, query_564259, nil, nil, nil)

var dataFlowsGet* = Call_DataFlowsGet_564247(name: "dataFlowsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/dataflows/{dataFlowName}",
    validator: validate_DataFlowsGet_564248, base: "", url: url_DataFlowsGet_564249,
    schemes: {Scheme.Https})
type
  Call_DataFlowsDelete_564275 = ref object of OpenApiRestCall_563566
proc url_DataFlowsDelete_564277(protocol: Scheme; host: string; base: string;
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

proc validate_DataFlowsDelete_564276(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a data flow.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: JString (required)
  ##               : The data flow name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564278 = path.getOrDefault("subscriptionId")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "subscriptionId", valid_564278
  var valid_564279 = path.getOrDefault("dataFlowName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "dataFlowName", valid_564279
  var valid_564280 = path.getOrDefault("resourceGroupName")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = nil)
  if valid_564280 != nil:
    section.add "resourceGroupName", valid_564280
  var valid_564281 = path.getOrDefault("factoryName")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = nil)
  if valid_564281 != nil:
    section.add "factoryName", valid_564281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564282 = query.getOrDefault("api-version")
  valid_564282 = validateParameter(valid_564282, JString, required = true,
                                 default = nil)
  if valid_564282 != nil:
    section.add "api-version", valid_564282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564283: Call_DataFlowsDelete_564275; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a data flow.
  ## 
  let valid = call_564283.validator(path, query, header, formData, body)
  let scheme = call_564283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564283.url(scheme.get, call_564283.host, call_564283.base,
                         call_564283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564283, url, valid)

proc call*(call_564284: Call_DataFlowsDelete_564275; apiVersion: string;
          subscriptionId: string; dataFlowName: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## dataFlowsDelete
  ## Deletes a data flow.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   dataFlowName: string (required)
  ##               : The data flow name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564285 = newJObject()
  var query_564286 = newJObject()
  add(query_564286, "api-version", newJString(apiVersion))
  add(path_564285, "subscriptionId", newJString(subscriptionId))
  add(path_564285, "dataFlowName", newJString(dataFlowName))
  add(path_564285, "resourceGroupName", newJString(resourceGroupName))
  add(path_564285, "factoryName", newJString(factoryName))
  result = call_564284.call(path_564285, query_564286, nil, nil, nil)

var dataFlowsDelete* = Call_DataFlowsDelete_564275(name: "dataFlowsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/dataflows/{dataFlowName}",
    validator: validate_DataFlowsDelete_564276, base: "", url: url_DataFlowsDelete_564277,
    schemes: {Scheme.Https})
type
  Call_DatasetsListByFactory_564287 = ref object of OpenApiRestCall_563566
proc url_DatasetsListByFactory_564289(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsListByFactory_564288(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists datasets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564290 = path.getOrDefault("subscriptionId")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "subscriptionId", valid_564290
  var valid_564291 = path.getOrDefault("resourceGroupName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "resourceGroupName", valid_564291
  var valid_564292 = path.getOrDefault("factoryName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "factoryName", valid_564292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564293 = query.getOrDefault("api-version")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "api-version", valid_564293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564294: Call_DatasetsListByFactory_564287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists datasets.
  ## 
  let valid = call_564294.validator(path, query, header, formData, body)
  let scheme = call_564294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564294.url(scheme.get, call_564294.host, call_564294.base,
                         call_564294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564294, url, valid)

proc call*(call_564295: Call_DatasetsListByFactory_564287; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## datasetsListByFactory
  ## Lists datasets.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564296 = newJObject()
  var query_564297 = newJObject()
  add(query_564297, "api-version", newJString(apiVersion))
  add(path_564296, "subscriptionId", newJString(subscriptionId))
  add(path_564296, "resourceGroupName", newJString(resourceGroupName))
  add(path_564296, "factoryName", newJString(factoryName))
  result = call_564295.call(path_564296, query_564297, nil, nil, nil)

var datasetsListByFactory* = Call_DatasetsListByFactory_564287(
    name: "datasetsListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets",
    validator: validate_DatasetsListByFactory_564288, base: "",
    url: url_DatasetsListByFactory_564289, schemes: {Scheme.Https})
type
  Call_DatasetsCreateOrUpdate_564311 = ref object of OpenApiRestCall_563566
proc url_DatasetsCreateOrUpdate_564313(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsCreateOrUpdate_564312(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetName: JString (required)
  ##              : The dataset name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `datasetName` field"
  var valid_564314 = path.getOrDefault("datasetName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "datasetName", valid_564314
  var valid_564315 = path.getOrDefault("subscriptionId")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "subscriptionId", valid_564315
  var valid_564316 = path.getOrDefault("resourceGroupName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "resourceGroupName", valid_564316
  var valid_564317 = path.getOrDefault("factoryName")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "factoryName", valid_564317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564318 = query.getOrDefault("api-version")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "api-version", valid_564318
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the dataset entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564319 = header.getOrDefault("If-Match")
  valid_564319 = validateParameter(valid_564319, JString, required = false,
                                 default = nil)
  if valid_564319 != nil:
    section.add "If-Match", valid_564319
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

proc call*(call_564321: Call_DatasetsCreateOrUpdate_564311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a dataset.
  ## 
  let valid = call_564321.validator(path, query, header, formData, body)
  let scheme = call_564321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564321.url(scheme.get, call_564321.host, call_564321.base,
                         call_564321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564321, url, valid)

proc call*(call_564322: Call_DatasetsCreateOrUpdate_564311; dataset: JsonNode;
          apiVersion: string; datasetName: string; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## datasetsCreateOrUpdate
  ## Creates or updates a dataset.
  ##   dataset: JObject (required)
  ##          : Dataset resource definition.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   datasetName: string (required)
  ##              : The dataset name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564323 = newJObject()
  var query_564324 = newJObject()
  var body_564325 = newJObject()
  if dataset != nil:
    body_564325 = dataset
  add(query_564324, "api-version", newJString(apiVersion))
  add(path_564323, "datasetName", newJString(datasetName))
  add(path_564323, "subscriptionId", newJString(subscriptionId))
  add(path_564323, "resourceGroupName", newJString(resourceGroupName))
  add(path_564323, "factoryName", newJString(factoryName))
  result = call_564322.call(path_564323, query_564324, nil, nil, body_564325)

var datasetsCreateOrUpdate* = Call_DatasetsCreateOrUpdate_564311(
    name: "datasetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsCreateOrUpdate_564312, base: "",
    url: url_DatasetsCreateOrUpdate_564313, schemes: {Scheme.Https})
type
  Call_DatasetsGet_564298 = ref object of OpenApiRestCall_563566
proc url_DatasetsGet_564300(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsGet_564299(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetName: JString (required)
  ##              : The dataset name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `datasetName` field"
  var valid_564301 = path.getOrDefault("datasetName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "datasetName", valid_564301
  var valid_564302 = path.getOrDefault("subscriptionId")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "subscriptionId", valid_564302
  var valid_564303 = path.getOrDefault("resourceGroupName")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "resourceGroupName", valid_564303
  var valid_564304 = path.getOrDefault("factoryName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "factoryName", valid_564304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564305 = query.getOrDefault("api-version")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "api-version", valid_564305
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the dataset entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_564306 = header.getOrDefault("If-None-Match")
  valid_564306 = validateParameter(valid_564306, JString, required = false,
                                 default = nil)
  if valid_564306 != nil:
    section.add "If-None-Match", valid_564306
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564307: Call_DatasetsGet_564298; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a dataset.
  ## 
  let valid = call_564307.validator(path, query, header, formData, body)
  let scheme = call_564307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564307.url(scheme.get, call_564307.host, call_564307.base,
                         call_564307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564307, url, valid)

proc call*(call_564308: Call_DatasetsGet_564298; apiVersion: string;
          datasetName: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## datasetsGet
  ## Gets a dataset.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   datasetName: string (required)
  ##              : The dataset name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564309 = newJObject()
  var query_564310 = newJObject()
  add(query_564310, "api-version", newJString(apiVersion))
  add(path_564309, "datasetName", newJString(datasetName))
  add(path_564309, "subscriptionId", newJString(subscriptionId))
  add(path_564309, "resourceGroupName", newJString(resourceGroupName))
  add(path_564309, "factoryName", newJString(factoryName))
  result = call_564308.call(path_564309, query_564310, nil, nil, nil)

var datasetsGet* = Call_DatasetsGet_564298(name: "datasetsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
                                        validator: validate_DatasetsGet_564299,
                                        base: "", url: url_DatasetsGet_564300,
                                        schemes: {Scheme.Https})
type
  Call_DatasetsDelete_564326 = ref object of OpenApiRestCall_563566
proc url_DatasetsDelete_564328(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsDelete_564327(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a dataset.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   datasetName: JString (required)
  ##              : The dataset name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `datasetName` field"
  var valid_564329 = path.getOrDefault("datasetName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "datasetName", valid_564329
  var valid_564330 = path.getOrDefault("subscriptionId")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "subscriptionId", valid_564330
  var valid_564331 = path.getOrDefault("resourceGroupName")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "resourceGroupName", valid_564331
  var valid_564332 = path.getOrDefault("factoryName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "factoryName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564334: Call_DatasetsDelete_564326; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a dataset.
  ## 
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_DatasetsDelete_564326; apiVersion: string;
          datasetName: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## datasetsDelete
  ## Deletes a dataset.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   datasetName: string (required)
  ##              : The dataset name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  add(query_564337, "api-version", newJString(apiVersion))
  add(path_564336, "datasetName", newJString(datasetName))
  add(path_564336, "subscriptionId", newJString(subscriptionId))
  add(path_564336, "resourceGroupName", newJString(resourceGroupName))
  add(path_564336, "factoryName", newJString(factoryName))
  result = call_564335.call(path_564336, query_564337, nil, nil, nil)

var datasetsDelete* = Call_DatasetsDelete_564326(name: "datasetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsDelete_564327, base: "", url: url_DatasetsDelete_564328,
    schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionDelete_564338 = ref object of OpenApiRestCall_563566
proc url_DataFlowDebugSessionDelete_564340(protocol: Scheme; host: string;
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

proc validate_DataFlowDebugSessionDelete_564339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a data flow debug session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564341 = path.getOrDefault("subscriptionId")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "subscriptionId", valid_564341
  var valid_564342 = path.getOrDefault("resourceGroupName")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "resourceGroupName", valid_564342
  var valid_564343 = path.getOrDefault("factoryName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "factoryName", valid_564343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564344 = query.getOrDefault("api-version")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "api-version", valid_564344
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

proc call*(call_564346: Call_DataFlowDebugSessionDelete_564338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a data flow debug session.
  ## 
  let valid = call_564346.validator(path, query, header, formData, body)
  let scheme = call_564346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564346.url(scheme.get, call_564346.host, call_564346.base,
                         call_564346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564346, url, valid)

proc call*(call_564347: Call_DataFlowDebugSessionDelete_564338; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string;
          request: JsonNode): Recallable =
  ## dataFlowDebugSessionDelete
  ## Deletes a data flow debug session.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   request: JObject (required)
  ##          : Data flow debug session definition for deletion
  var path_564348 = newJObject()
  var query_564349 = newJObject()
  var body_564350 = newJObject()
  add(query_564349, "api-version", newJString(apiVersion))
  add(path_564348, "subscriptionId", newJString(subscriptionId))
  add(path_564348, "resourceGroupName", newJString(resourceGroupName))
  add(path_564348, "factoryName", newJString(factoryName))
  if request != nil:
    body_564350 = request
  result = call_564347.call(path_564348, query_564349, nil, nil, body_564350)

var dataFlowDebugSessionDelete* = Call_DataFlowDebugSessionDelete_564338(
    name: "dataFlowDebugSessionDelete", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/deleteDataFlowDebugSession",
    validator: validate_DataFlowDebugSessionDelete_564339, base: "",
    url: url_DataFlowDebugSessionDelete_564340, schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionExecuteCommand_564351 = ref object of OpenApiRestCall_563566
proc url_DataFlowDebugSessionExecuteCommand_564353(protocol: Scheme; host: string;
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

proc validate_DataFlowDebugSessionExecuteCommand_564352(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Execute a data flow debug command.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564354 = path.getOrDefault("subscriptionId")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "subscriptionId", valid_564354
  var valid_564355 = path.getOrDefault("resourceGroupName")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "resourceGroupName", valid_564355
  var valid_564356 = path.getOrDefault("factoryName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "factoryName", valid_564356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564357 = query.getOrDefault("api-version")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "api-version", valid_564357
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

proc call*(call_564359: Call_DataFlowDebugSessionExecuteCommand_564351;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Execute a data flow debug command.
  ## 
  let valid = call_564359.validator(path, query, header, formData, body)
  let scheme = call_564359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564359.url(scheme.get, call_564359.host, call_564359.base,
                         call_564359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564359, url, valid)

proc call*(call_564360: Call_DataFlowDebugSessionExecuteCommand_564351;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string; request: JsonNode): Recallable =
  ## dataFlowDebugSessionExecuteCommand
  ## Execute a data flow debug command.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   request: JObject (required)
  ##          : Data flow debug command definition.
  var path_564361 = newJObject()
  var query_564362 = newJObject()
  var body_564363 = newJObject()
  add(query_564362, "api-version", newJString(apiVersion))
  add(path_564361, "subscriptionId", newJString(subscriptionId))
  add(path_564361, "resourceGroupName", newJString(resourceGroupName))
  add(path_564361, "factoryName", newJString(factoryName))
  if request != nil:
    body_564363 = request
  result = call_564360.call(path_564361, query_564362, nil, nil, body_564363)

var dataFlowDebugSessionExecuteCommand* = Call_DataFlowDebugSessionExecuteCommand_564351(
    name: "dataFlowDebugSessionExecuteCommand", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/executeDataFlowDebugCommand",
    validator: validate_DataFlowDebugSessionExecuteCommand_564352, base: "",
    url: url_DataFlowDebugSessionExecuteCommand_564353, schemes: {Scheme.Https})
type
  Call_FactoriesGetDataPlaneAccess_564364 = ref object of OpenApiRestCall_563566
proc url_FactoriesGetDataPlaneAccess_564366(protocol: Scheme; host: string;
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

proc validate_FactoriesGetDataPlaneAccess_564365(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get Data Plane access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564367 = path.getOrDefault("subscriptionId")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "subscriptionId", valid_564367
  var valid_564368 = path.getOrDefault("resourceGroupName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "resourceGroupName", valid_564368
  var valid_564369 = path.getOrDefault("factoryName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "factoryName", valid_564369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564370 = query.getOrDefault("api-version")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "api-version", valid_564370
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

proc call*(call_564372: Call_FactoriesGetDataPlaneAccess_564364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Data Plane access.
  ## 
  let valid = call_564372.validator(path, query, header, formData, body)
  let scheme = call_564372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564372.url(scheme.get, call_564372.host, call_564372.base,
                         call_564372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564372, url, valid)

proc call*(call_564373: Call_FactoriesGetDataPlaneAccess_564364;
          apiVersion: string; policy: JsonNode; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## factoriesGetDataPlaneAccess
  ## Get Data Plane access.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   policy: JObject (required)
  ##         : Data Plane user access policy definition.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564374 = newJObject()
  var query_564375 = newJObject()
  var body_564376 = newJObject()
  add(query_564375, "api-version", newJString(apiVersion))
  if policy != nil:
    body_564376 = policy
  add(path_564374, "subscriptionId", newJString(subscriptionId))
  add(path_564374, "resourceGroupName", newJString(resourceGroupName))
  add(path_564374, "factoryName", newJString(factoryName))
  result = call_564373.call(path_564374, query_564375, nil, nil, body_564376)

var factoriesGetDataPlaneAccess* = Call_FactoriesGetDataPlaneAccess_564364(
    name: "factoriesGetDataPlaneAccess", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/getDataPlaneAccess",
    validator: validate_FactoriesGetDataPlaneAccess_564365, base: "",
    url: url_FactoriesGetDataPlaneAccess_564366, schemes: {Scheme.Https})
type
  Call_ExposureControlGetFeatureValueByFactory_564377 = ref object of OpenApiRestCall_563566
proc url_ExposureControlGetFeatureValueByFactory_564379(protocol: Scheme;
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

proc validate_ExposureControlGetFeatureValueByFactory_564378(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get exposure control feature for specific factory.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564380 = path.getOrDefault("subscriptionId")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "subscriptionId", valid_564380
  var valid_564381 = path.getOrDefault("resourceGroupName")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "resourceGroupName", valid_564381
  var valid_564382 = path.getOrDefault("factoryName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "factoryName", valid_564382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564383 = query.getOrDefault("api-version")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "api-version", valid_564383
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

proc call*(call_564385: Call_ExposureControlGetFeatureValueByFactory_564377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get exposure control feature for specific factory.
  ## 
  let valid = call_564385.validator(path, query, header, formData, body)
  let scheme = call_564385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564385.url(scheme.get, call_564385.host, call_564385.base,
                         call_564385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564385, url, valid)

proc call*(call_564386: Call_ExposureControlGetFeatureValueByFactory_564377;
          apiVersion: string; exposureControlRequest: JsonNode;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## exposureControlGetFeatureValueByFactory
  ## Get exposure control feature for specific factory.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   exposureControlRequest: JObject (required)
  ##                         : The exposure control request.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564387 = newJObject()
  var query_564388 = newJObject()
  var body_564389 = newJObject()
  add(query_564388, "api-version", newJString(apiVersion))
  if exposureControlRequest != nil:
    body_564389 = exposureControlRequest
  add(path_564387, "subscriptionId", newJString(subscriptionId))
  add(path_564387, "resourceGroupName", newJString(resourceGroupName))
  add(path_564387, "factoryName", newJString(factoryName))
  result = call_564386.call(path_564387, query_564388, nil, nil, body_564389)

var exposureControlGetFeatureValueByFactory* = Call_ExposureControlGetFeatureValueByFactory_564377(
    name: "exposureControlGetFeatureValueByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/getFeatureValue",
    validator: validate_ExposureControlGetFeatureValueByFactory_564378, base: "",
    url: url_ExposureControlGetFeatureValueByFactory_564379,
    schemes: {Scheme.Https})
type
  Call_FactoriesGetGitHubAccessToken_564390 = ref object of OpenApiRestCall_563566
proc url_FactoriesGetGitHubAccessToken_564392(protocol: Scheme; host: string;
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

proc validate_FactoriesGetGitHubAccessToken_564391(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get GitHub Access Token.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564393 = path.getOrDefault("subscriptionId")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "subscriptionId", valid_564393
  var valid_564394 = path.getOrDefault("resourceGroupName")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "resourceGroupName", valid_564394
  var valid_564395 = path.getOrDefault("factoryName")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "factoryName", valid_564395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564396 = query.getOrDefault("api-version")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "api-version", valid_564396
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

proc call*(call_564398: Call_FactoriesGetGitHubAccessToken_564390; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get GitHub Access Token.
  ## 
  let valid = call_564398.validator(path, query, header, formData, body)
  let scheme = call_564398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564398.url(scheme.get, call_564398.host, call_564398.base,
                         call_564398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564398, url, valid)

proc call*(call_564399: Call_FactoriesGetGitHubAccessToken_564390;
          apiVersion: string; gitHubAccessTokenRequest: JsonNode;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## factoriesGetGitHubAccessToken
  ## Get GitHub Access Token.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   gitHubAccessTokenRequest: JObject (required)
  ##                           : Get GitHub access token request definition.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564400 = newJObject()
  var query_564401 = newJObject()
  var body_564402 = newJObject()
  add(query_564401, "api-version", newJString(apiVersion))
  if gitHubAccessTokenRequest != nil:
    body_564402 = gitHubAccessTokenRequest
  add(path_564400, "subscriptionId", newJString(subscriptionId))
  add(path_564400, "resourceGroupName", newJString(resourceGroupName))
  add(path_564400, "factoryName", newJString(factoryName))
  result = call_564399.call(path_564400, query_564401, nil, nil, body_564402)

var factoriesGetGitHubAccessToken* = Call_FactoriesGetGitHubAccessToken_564390(
    name: "factoriesGetGitHubAccessToken", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/getGitHubAccessToken",
    validator: validate_FactoriesGetGitHubAccessToken_564391, base: "",
    url: url_FactoriesGetGitHubAccessToken_564392, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListByFactory_564403 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesListByFactory_564405(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesListByFactory_564404(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists integration runtimes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564406 = path.getOrDefault("subscriptionId")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "subscriptionId", valid_564406
  var valid_564407 = path.getOrDefault("resourceGroupName")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "resourceGroupName", valid_564407
  var valid_564408 = path.getOrDefault("factoryName")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "factoryName", valid_564408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564409 = query.getOrDefault("api-version")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "api-version", valid_564409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564410: Call_IntegrationRuntimesListByFactory_564403;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists integration runtimes.
  ## 
  let valid = call_564410.validator(path, query, header, formData, body)
  let scheme = call_564410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564410.url(scheme.get, call_564410.host, call_564410.base,
                         call_564410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564410, url, valid)

proc call*(call_564411: Call_IntegrationRuntimesListByFactory_564403;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## integrationRuntimesListByFactory
  ## Lists integration runtimes.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564412 = newJObject()
  var query_564413 = newJObject()
  add(query_564413, "api-version", newJString(apiVersion))
  add(path_564412, "subscriptionId", newJString(subscriptionId))
  add(path_564412, "resourceGroupName", newJString(resourceGroupName))
  add(path_564412, "factoryName", newJString(factoryName))
  result = call_564411.call(path_564412, query_564413, nil, nil, nil)

var integrationRuntimesListByFactory* = Call_IntegrationRuntimesListByFactory_564403(
    name: "integrationRuntimesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes",
    validator: validate_IntegrationRuntimesListByFactory_564404, base: "",
    url: url_IntegrationRuntimesListByFactory_564405, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesCreateOrUpdate_564427 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesCreateOrUpdate_564429(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesCreateOrUpdate_564428(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564430 = path.getOrDefault("integrationRuntimeName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "integrationRuntimeName", valid_564430
  var valid_564431 = path.getOrDefault("subscriptionId")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "subscriptionId", valid_564431
  var valid_564432 = path.getOrDefault("resourceGroupName")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "resourceGroupName", valid_564432
  var valid_564433 = path.getOrDefault("factoryName")
  valid_564433 = validateParameter(valid_564433, JString, required = true,
                                 default = nil)
  if valid_564433 != nil:
    section.add "factoryName", valid_564433
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564434 = query.getOrDefault("api-version")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "api-version", valid_564434
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the integration runtime entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564435 = header.getOrDefault("If-Match")
  valid_564435 = validateParameter(valid_564435, JString, required = false,
                                 default = nil)
  if valid_564435 != nil:
    section.add "If-Match", valid_564435
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

proc call*(call_564437: Call_IntegrationRuntimesCreateOrUpdate_564427;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration runtime.
  ## 
  let valid = call_564437.validator(path, query, header, formData, body)
  let scheme = call_564437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564437.url(scheme.get, call_564437.host, call_564437.base,
                         call_564437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564437, url, valid)

proc call*(call_564438: Call_IntegrationRuntimesCreateOrUpdate_564427;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string;
          integrationRuntime: JsonNode): Recallable =
  ## integrationRuntimesCreateOrUpdate
  ## Creates or updates an integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   integrationRuntime: JObject (required)
  ##                     : Integration runtime resource definition.
  var path_564439 = newJObject()
  var query_564440 = newJObject()
  var body_564441 = newJObject()
  add(query_564440, "api-version", newJString(apiVersion))
  add(path_564439, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564439, "subscriptionId", newJString(subscriptionId))
  add(path_564439, "resourceGroupName", newJString(resourceGroupName))
  add(path_564439, "factoryName", newJString(factoryName))
  if integrationRuntime != nil:
    body_564441 = integrationRuntime
  result = call_564438.call(path_564439, query_564440, nil, nil, body_564441)

var integrationRuntimesCreateOrUpdate* = Call_IntegrationRuntimesCreateOrUpdate_564427(
    name: "integrationRuntimesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesCreateOrUpdate_564428, base: "",
    url: url_IntegrationRuntimesCreateOrUpdate_564429, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGet_564414 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesGet_564416(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationRuntimesGet_564415(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564417 = path.getOrDefault("integrationRuntimeName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "integrationRuntimeName", valid_564417
  var valid_564418 = path.getOrDefault("subscriptionId")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "subscriptionId", valid_564418
  var valid_564419 = path.getOrDefault("resourceGroupName")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = nil)
  if valid_564419 != nil:
    section.add "resourceGroupName", valid_564419
  var valid_564420 = path.getOrDefault("factoryName")
  valid_564420 = validateParameter(valid_564420, JString, required = true,
                                 default = nil)
  if valid_564420 != nil:
    section.add "factoryName", valid_564420
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564421 = query.getOrDefault("api-version")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "api-version", valid_564421
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the integration runtime entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_564422 = header.getOrDefault("If-None-Match")
  valid_564422 = validateParameter(valid_564422, JString, required = false,
                                 default = nil)
  if valid_564422 != nil:
    section.add "If-None-Match", valid_564422
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564423: Call_IntegrationRuntimesGet_564414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration runtime.
  ## 
  let valid = call_564423.validator(path, query, header, formData, body)
  let scheme = call_564423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564423.url(scheme.get, call_564423.host, call_564423.base,
                         call_564423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564423, url, valid)

proc call*(call_564424: Call_IntegrationRuntimesGet_564414; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesGet
  ## Gets an integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564425 = newJObject()
  var query_564426 = newJObject()
  add(query_564426, "api-version", newJString(apiVersion))
  add(path_564425, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564425, "subscriptionId", newJString(subscriptionId))
  add(path_564425, "resourceGroupName", newJString(resourceGroupName))
  add(path_564425, "factoryName", newJString(factoryName))
  result = call_564424.call(path_564425, query_564426, nil, nil, nil)

var integrationRuntimesGet* = Call_IntegrationRuntimesGet_564414(
    name: "integrationRuntimesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesGet_564415, base: "",
    url: url_IntegrationRuntimesGet_564416, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpdate_564454 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesUpdate_564456(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesUpdate_564455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564457 = path.getOrDefault("integrationRuntimeName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "integrationRuntimeName", valid_564457
  var valid_564458 = path.getOrDefault("subscriptionId")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "subscriptionId", valid_564458
  var valid_564459 = path.getOrDefault("resourceGroupName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "resourceGroupName", valid_564459
  var valid_564460 = path.getOrDefault("factoryName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "factoryName", valid_564460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564461 = query.getOrDefault("api-version")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "api-version", valid_564461
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

proc call*(call_564463: Call_IntegrationRuntimesUpdate_564454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration runtime.
  ## 
  let valid = call_564463.validator(path, query, header, formData, body)
  let scheme = call_564463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564463.url(scheme.get, call_564463.host, call_564463.base,
                         call_564463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564463, url, valid)

proc call*(call_564464: Call_IntegrationRuntimesUpdate_564454; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          resourceGroupName: string; factoryName: string;
          updateIntegrationRuntimeRequest: JsonNode): Recallable =
  ## integrationRuntimesUpdate
  ## Updates an integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   updateIntegrationRuntimeRequest: JObject (required)
  ##                                  : The parameters for updating an integration runtime.
  var path_564465 = newJObject()
  var query_564466 = newJObject()
  var body_564467 = newJObject()
  add(query_564466, "api-version", newJString(apiVersion))
  add(path_564465, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564465, "subscriptionId", newJString(subscriptionId))
  add(path_564465, "resourceGroupName", newJString(resourceGroupName))
  add(path_564465, "factoryName", newJString(factoryName))
  if updateIntegrationRuntimeRequest != nil:
    body_564467 = updateIntegrationRuntimeRequest
  result = call_564464.call(path_564465, query_564466, nil, nil, body_564467)

var integrationRuntimesUpdate* = Call_IntegrationRuntimesUpdate_564454(
    name: "integrationRuntimesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesUpdate_564455, base: "",
    url: url_IntegrationRuntimesUpdate_564456, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesDelete_564442 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesDelete_564444(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesDelete_564443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564445 = path.getOrDefault("integrationRuntimeName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "integrationRuntimeName", valid_564445
  var valid_564446 = path.getOrDefault("subscriptionId")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "subscriptionId", valid_564446
  var valid_564447 = path.getOrDefault("resourceGroupName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "resourceGroupName", valid_564447
  var valid_564448 = path.getOrDefault("factoryName")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "factoryName", valid_564448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564449 = query.getOrDefault("api-version")
  valid_564449 = validateParameter(valid_564449, JString, required = true,
                                 default = nil)
  if valid_564449 != nil:
    section.add "api-version", valid_564449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564450: Call_IntegrationRuntimesDelete_564442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration runtime.
  ## 
  let valid = call_564450.validator(path, query, header, formData, body)
  let scheme = call_564450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564450.url(scheme.get, call_564450.host, call_564450.base,
                         call_564450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564450, url, valid)

proc call*(call_564451: Call_IntegrationRuntimesDelete_564442; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesDelete
  ## Deletes an integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564452 = newJObject()
  var query_564453 = newJObject()
  add(query_564453, "api-version", newJString(apiVersion))
  add(path_564452, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564452, "subscriptionId", newJString(subscriptionId))
  add(path_564452, "resourceGroupName", newJString(resourceGroupName))
  add(path_564452, "factoryName", newJString(factoryName))
  result = call_564451.call(path_564452, query_564453, nil, nil, nil)

var integrationRuntimesDelete* = Call_IntegrationRuntimesDelete_564442(
    name: "integrationRuntimesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesDelete_564443, base: "",
    url: url_IntegrationRuntimesDelete_564444, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetConnectionInfo_564468 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesGetConnectionInfo_564470(protocol: Scheme;
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

proc validate_IntegrationRuntimesGetConnectionInfo_564469(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564471 = path.getOrDefault("integrationRuntimeName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "integrationRuntimeName", valid_564471
  var valid_564472 = path.getOrDefault("subscriptionId")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "subscriptionId", valid_564472
  var valid_564473 = path.getOrDefault("resourceGroupName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "resourceGroupName", valid_564473
  var valid_564474 = path.getOrDefault("factoryName")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "factoryName", valid_564474
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564475 = query.getOrDefault("api-version")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "api-version", valid_564475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564476: Call_IntegrationRuntimesGetConnectionInfo_564468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ## 
  let valid = call_564476.validator(path, query, header, formData, body)
  let scheme = call_564476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564476.url(scheme.get, call_564476.host, call_564476.base,
                         call_564476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564476, url, valid)

proc call*(call_564477: Call_IntegrationRuntimesGetConnectionInfo_564468;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesGetConnectionInfo
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564478 = newJObject()
  var query_564479 = newJObject()
  add(query_564479, "api-version", newJString(apiVersion))
  add(path_564478, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564478, "subscriptionId", newJString(subscriptionId))
  add(path_564478, "resourceGroupName", newJString(resourceGroupName))
  add(path_564478, "factoryName", newJString(factoryName))
  result = call_564477.call(path_564478, query_564479, nil, nil, nil)

var integrationRuntimesGetConnectionInfo* = Call_IntegrationRuntimesGetConnectionInfo_564468(
    name: "integrationRuntimesGetConnectionInfo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getConnectionInfo",
    validator: validate_IntegrationRuntimesGetConnectionInfo_564469, base: "",
    url: url_IntegrationRuntimesGetConnectionInfo_564470, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeObjectMetadataGet_564480 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimeObjectMetadataGet_564482(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeObjectMetadataGet_564481(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a SSIS integration runtime object metadata by specified path. The return is pageable metadata list.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564483 = path.getOrDefault("integrationRuntimeName")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "integrationRuntimeName", valid_564483
  var valid_564484 = path.getOrDefault("subscriptionId")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "subscriptionId", valid_564484
  var valid_564485 = path.getOrDefault("resourceGroupName")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "resourceGroupName", valid_564485
  var valid_564486 = path.getOrDefault("factoryName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "factoryName", valid_564486
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564487 = query.getOrDefault("api-version")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "api-version", valid_564487
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

proc call*(call_564489: Call_IntegrationRuntimeObjectMetadataGet_564480;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a SSIS integration runtime object metadata by specified path. The return is pageable metadata list.
  ## 
  let valid = call_564489.validator(path, query, header, formData, body)
  let scheme = call_564489.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564489.url(scheme.get, call_564489.host, call_564489.base,
                         call_564489.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564489, url, valid)

proc call*(call_564490: Call_IntegrationRuntimeObjectMetadataGet_564480;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string;
          getMetadataRequest: JsonNode = nil): Recallable =
  ## integrationRuntimeObjectMetadataGet
  ## Get a SSIS integration runtime object metadata by specified path. The return is pageable metadata list.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   getMetadataRequest: JObject
  ##                     : The parameters for getting a SSIS object metadata.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564491 = newJObject()
  var query_564492 = newJObject()
  var body_564493 = newJObject()
  add(query_564492, "api-version", newJString(apiVersion))
  add(path_564491, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564491, "subscriptionId", newJString(subscriptionId))
  add(path_564491, "resourceGroupName", newJString(resourceGroupName))
  if getMetadataRequest != nil:
    body_564493 = getMetadataRequest
  add(path_564491, "factoryName", newJString(factoryName))
  result = call_564490.call(path_564491, query_564492, nil, nil, body_564493)

var integrationRuntimeObjectMetadataGet* = Call_IntegrationRuntimeObjectMetadataGet_564480(
    name: "integrationRuntimeObjectMetadataGet", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getObjectMetadata",
    validator: validate_IntegrationRuntimeObjectMetadataGet_564481, base: "",
    url: url_IntegrationRuntimeObjectMetadataGet_564482, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetStatus_564494 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesGetStatus_564496(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesGetStatus_564495(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets detailed status information for an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564497 = path.getOrDefault("integrationRuntimeName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "integrationRuntimeName", valid_564497
  var valid_564498 = path.getOrDefault("subscriptionId")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "subscriptionId", valid_564498
  var valid_564499 = path.getOrDefault("resourceGroupName")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "resourceGroupName", valid_564499
  var valid_564500 = path.getOrDefault("factoryName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "factoryName", valid_564500
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564501 = query.getOrDefault("api-version")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "api-version", valid_564501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564502: Call_IntegrationRuntimesGetStatus_564494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets detailed status information for an integration runtime.
  ## 
  let valid = call_564502.validator(path, query, header, formData, body)
  let scheme = call_564502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564502.url(scheme.get, call_564502.host, call_564502.base,
                         call_564502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564502, url, valid)

proc call*(call_564503: Call_IntegrationRuntimesGetStatus_564494;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesGetStatus
  ## Gets detailed status information for an integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564504 = newJObject()
  var query_564505 = newJObject()
  add(query_564505, "api-version", newJString(apiVersion))
  add(path_564504, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564504, "subscriptionId", newJString(subscriptionId))
  add(path_564504, "resourceGroupName", newJString(resourceGroupName))
  add(path_564504, "factoryName", newJString(factoryName))
  result = call_564503.call(path_564504, query_564505, nil, nil, nil)

var integrationRuntimesGetStatus* = Call_IntegrationRuntimesGetStatus_564494(
    name: "integrationRuntimesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getStatus",
    validator: validate_IntegrationRuntimesGetStatus_564495, base: "",
    url: url_IntegrationRuntimesGetStatus_564496, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_564506 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesCreateLinkedIntegrationRuntime_564508(
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

proc validate_IntegrationRuntimesCreateLinkedIntegrationRuntime_564507(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Create a linked integration runtime entry in a shared integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564509 = path.getOrDefault("integrationRuntimeName")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "integrationRuntimeName", valid_564509
  var valid_564510 = path.getOrDefault("subscriptionId")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "subscriptionId", valid_564510
  var valid_564511 = path.getOrDefault("resourceGroupName")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "resourceGroupName", valid_564511
  var valid_564512 = path.getOrDefault("factoryName")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "factoryName", valid_564512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564513 = query.getOrDefault("api-version")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "api-version", valid_564513
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

proc call*(call_564515: Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_564506;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a linked integration runtime entry in a shared integration runtime.
  ## 
  let valid = call_564515.validator(path, query, header, formData, body)
  let scheme = call_564515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564515.url(scheme.get, call_564515.host, call_564515.base,
                         call_564515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564515, url, valid)

proc call*(call_564516: Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_564506;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string;
          createLinkedIntegrationRuntimeRequest: JsonNode): Recallable =
  ## integrationRuntimesCreateLinkedIntegrationRuntime
  ## Create a linked integration runtime entry in a shared integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   createLinkedIntegrationRuntimeRequest: JObject (required)
  ##                                        : The linked integration runtime properties.
  var path_564517 = newJObject()
  var query_564518 = newJObject()
  var body_564519 = newJObject()
  add(query_564518, "api-version", newJString(apiVersion))
  add(path_564517, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564517, "subscriptionId", newJString(subscriptionId))
  add(path_564517, "resourceGroupName", newJString(resourceGroupName))
  add(path_564517, "factoryName", newJString(factoryName))
  if createLinkedIntegrationRuntimeRequest != nil:
    body_564519 = createLinkedIntegrationRuntimeRequest
  result = call_564516.call(path_564517, query_564518, nil, nil, body_564519)

var integrationRuntimesCreateLinkedIntegrationRuntime* = Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_564506(
    name: "integrationRuntimesCreateLinkedIntegrationRuntime",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/linkedIntegrationRuntime",
    validator: validate_IntegrationRuntimesCreateLinkedIntegrationRuntime_564507,
    base: "", url: url_IntegrationRuntimesCreateLinkedIntegrationRuntime_564508,
    schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListAuthKeys_564520 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesListAuthKeys_564522(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesListAuthKeys_564521(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the authentication keys for an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564523 = path.getOrDefault("integrationRuntimeName")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "integrationRuntimeName", valid_564523
  var valid_564524 = path.getOrDefault("subscriptionId")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "subscriptionId", valid_564524
  var valid_564525 = path.getOrDefault("resourceGroupName")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "resourceGroupName", valid_564525
  var valid_564526 = path.getOrDefault("factoryName")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "factoryName", valid_564526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564527 = query.getOrDefault("api-version")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "api-version", valid_564527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564528: Call_IntegrationRuntimesListAuthKeys_564520;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authentication keys for an integration runtime.
  ## 
  let valid = call_564528.validator(path, query, header, formData, body)
  let scheme = call_564528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564528.url(scheme.get, call_564528.host, call_564528.base,
                         call_564528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564528, url, valid)

proc call*(call_564529: Call_IntegrationRuntimesListAuthKeys_564520;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesListAuthKeys
  ## Retrieves the authentication keys for an integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564530 = newJObject()
  var query_564531 = newJObject()
  add(query_564531, "api-version", newJString(apiVersion))
  add(path_564530, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564530, "subscriptionId", newJString(subscriptionId))
  add(path_564530, "resourceGroupName", newJString(resourceGroupName))
  add(path_564530, "factoryName", newJString(factoryName))
  result = call_564529.call(path_564530, query_564531, nil, nil, nil)

var integrationRuntimesListAuthKeys* = Call_IntegrationRuntimesListAuthKeys_564520(
    name: "integrationRuntimesListAuthKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/listAuthKeys",
    validator: validate_IntegrationRuntimesListAuthKeys_564521, base: "",
    url: url_IntegrationRuntimesListAuthKeys_564522, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetMonitoringData_564532 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesGetMonitoringData_564534(protocol: Scheme;
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

proc validate_IntegrationRuntimesGetMonitoringData_564533(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564535 = path.getOrDefault("integrationRuntimeName")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "integrationRuntimeName", valid_564535
  var valid_564536 = path.getOrDefault("subscriptionId")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "subscriptionId", valid_564536
  var valid_564537 = path.getOrDefault("resourceGroupName")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "resourceGroupName", valid_564537
  var valid_564538 = path.getOrDefault("factoryName")
  valid_564538 = validateParameter(valid_564538, JString, required = true,
                                 default = nil)
  if valid_564538 != nil:
    section.add "factoryName", valid_564538
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564539 = query.getOrDefault("api-version")
  valid_564539 = validateParameter(valid_564539, JString, required = true,
                                 default = nil)
  if valid_564539 != nil:
    section.add "api-version", valid_564539
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564540: Call_IntegrationRuntimesGetMonitoringData_564532;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ## 
  let valid = call_564540.validator(path, query, header, formData, body)
  let scheme = call_564540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564540.url(scheme.get, call_564540.host, call_564540.base,
                         call_564540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564540, url, valid)

proc call*(call_564541: Call_IntegrationRuntimesGetMonitoringData_564532;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesGetMonitoringData
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564542 = newJObject()
  var query_564543 = newJObject()
  add(query_564543, "api-version", newJString(apiVersion))
  add(path_564542, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564542, "subscriptionId", newJString(subscriptionId))
  add(path_564542, "resourceGroupName", newJString(resourceGroupName))
  add(path_564542, "factoryName", newJString(factoryName))
  result = call_564541.call(path_564542, query_564543, nil, nil, nil)

var integrationRuntimesGetMonitoringData* = Call_IntegrationRuntimesGetMonitoringData_564532(
    name: "integrationRuntimesGetMonitoringData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/monitoringData",
    validator: validate_IntegrationRuntimesGetMonitoringData_564533, base: "",
    url: url_IntegrationRuntimesGetMonitoringData_564534, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesGet_564544 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimeNodesGet_564546(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesGet_564545(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564547 = path.getOrDefault("integrationRuntimeName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "integrationRuntimeName", valid_564547
  var valid_564548 = path.getOrDefault("subscriptionId")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "subscriptionId", valid_564548
  var valid_564549 = path.getOrDefault("nodeName")
  valid_564549 = validateParameter(valid_564549, JString, required = true,
                                 default = nil)
  if valid_564549 != nil:
    section.add "nodeName", valid_564549
  var valid_564550 = path.getOrDefault("resourceGroupName")
  valid_564550 = validateParameter(valid_564550, JString, required = true,
                                 default = nil)
  if valid_564550 != nil:
    section.add "resourceGroupName", valid_564550
  var valid_564551 = path.getOrDefault("factoryName")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "factoryName", valid_564551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564552 = query.getOrDefault("api-version")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = nil)
  if valid_564552 != nil:
    section.add "api-version", valid_564552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564553: Call_IntegrationRuntimeNodesGet_564544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a self-hosted integration runtime node.
  ## 
  let valid = call_564553.validator(path, query, header, formData, body)
  let scheme = call_564553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564553.url(scheme.get, call_564553.host, call_564553.base,
                         call_564553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564553, url, valid)

proc call*(call_564554: Call_IntegrationRuntimeNodesGet_564544; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string; nodeName: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimeNodesGet
  ## Gets a self-hosted integration runtime node.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564555 = newJObject()
  var query_564556 = newJObject()
  add(query_564556, "api-version", newJString(apiVersion))
  add(path_564555, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564555, "subscriptionId", newJString(subscriptionId))
  add(path_564555, "nodeName", newJString(nodeName))
  add(path_564555, "resourceGroupName", newJString(resourceGroupName))
  add(path_564555, "factoryName", newJString(factoryName))
  result = call_564554.call(path_564555, query_564556, nil, nil, nil)

var integrationRuntimeNodesGet* = Call_IntegrationRuntimeNodesGet_564544(
    name: "integrationRuntimeNodesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesGet_564545, base: "",
    url: url_IntegrationRuntimeNodesGet_564546, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesUpdate_564570 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimeNodesUpdate_564572(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesUpdate_564571(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564573 = path.getOrDefault("integrationRuntimeName")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "integrationRuntimeName", valid_564573
  var valid_564574 = path.getOrDefault("subscriptionId")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "subscriptionId", valid_564574
  var valid_564575 = path.getOrDefault("nodeName")
  valid_564575 = validateParameter(valid_564575, JString, required = true,
                                 default = nil)
  if valid_564575 != nil:
    section.add "nodeName", valid_564575
  var valid_564576 = path.getOrDefault("resourceGroupName")
  valid_564576 = validateParameter(valid_564576, JString, required = true,
                                 default = nil)
  if valid_564576 != nil:
    section.add "resourceGroupName", valid_564576
  var valid_564577 = path.getOrDefault("factoryName")
  valid_564577 = validateParameter(valid_564577, JString, required = true,
                                 default = nil)
  if valid_564577 != nil:
    section.add "factoryName", valid_564577
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564578 = query.getOrDefault("api-version")
  valid_564578 = validateParameter(valid_564578, JString, required = true,
                                 default = nil)
  if valid_564578 != nil:
    section.add "api-version", valid_564578
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

proc call*(call_564580: Call_IntegrationRuntimeNodesUpdate_564570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a self-hosted integration runtime node.
  ## 
  let valid = call_564580.validator(path, query, header, formData, body)
  let scheme = call_564580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564580.url(scheme.get, call_564580.host, call_564580.base,
                         call_564580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564580, url, valid)

proc call*(call_564581: Call_IntegrationRuntimeNodesUpdate_564570;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; nodeName: string;
          updateIntegrationRuntimeNodeRequest: JsonNode;
          resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimeNodesUpdate
  ## Updates a self-hosted integration runtime node.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   updateIntegrationRuntimeNodeRequest: JObject (required)
  ##                                      : The parameters for updating an integration runtime node.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564582 = newJObject()
  var query_564583 = newJObject()
  var body_564584 = newJObject()
  add(query_564583, "api-version", newJString(apiVersion))
  add(path_564582, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564582, "subscriptionId", newJString(subscriptionId))
  add(path_564582, "nodeName", newJString(nodeName))
  if updateIntegrationRuntimeNodeRequest != nil:
    body_564584 = updateIntegrationRuntimeNodeRequest
  add(path_564582, "resourceGroupName", newJString(resourceGroupName))
  add(path_564582, "factoryName", newJString(factoryName))
  result = call_564581.call(path_564582, query_564583, nil, nil, body_564584)

var integrationRuntimeNodesUpdate* = Call_IntegrationRuntimeNodesUpdate_564570(
    name: "integrationRuntimeNodesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesUpdate_564571, base: "",
    url: url_IntegrationRuntimeNodesUpdate_564572, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesDelete_564557 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimeNodesDelete_564559(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesDelete_564558(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564560 = path.getOrDefault("integrationRuntimeName")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "integrationRuntimeName", valid_564560
  var valid_564561 = path.getOrDefault("subscriptionId")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = nil)
  if valid_564561 != nil:
    section.add "subscriptionId", valid_564561
  var valid_564562 = path.getOrDefault("nodeName")
  valid_564562 = validateParameter(valid_564562, JString, required = true,
                                 default = nil)
  if valid_564562 != nil:
    section.add "nodeName", valid_564562
  var valid_564563 = path.getOrDefault("resourceGroupName")
  valid_564563 = validateParameter(valid_564563, JString, required = true,
                                 default = nil)
  if valid_564563 != nil:
    section.add "resourceGroupName", valid_564563
  var valid_564564 = path.getOrDefault("factoryName")
  valid_564564 = validateParameter(valid_564564, JString, required = true,
                                 default = nil)
  if valid_564564 != nil:
    section.add "factoryName", valid_564564
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564565 = query.getOrDefault("api-version")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "api-version", valid_564565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564566: Call_IntegrationRuntimeNodesDelete_564557; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a self-hosted integration runtime node.
  ## 
  let valid = call_564566.validator(path, query, header, formData, body)
  let scheme = call_564566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564566.url(scheme.get, call_564566.host, call_564566.base,
                         call_564566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564566, url, valid)

proc call*(call_564567: Call_IntegrationRuntimeNodesDelete_564557;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; nodeName: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## integrationRuntimeNodesDelete
  ## Deletes a self-hosted integration runtime node.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564568 = newJObject()
  var query_564569 = newJObject()
  add(query_564569, "api-version", newJString(apiVersion))
  add(path_564568, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564568, "subscriptionId", newJString(subscriptionId))
  add(path_564568, "nodeName", newJString(nodeName))
  add(path_564568, "resourceGroupName", newJString(resourceGroupName))
  add(path_564568, "factoryName", newJString(factoryName))
  result = call_564567.call(path_564568, query_564569, nil, nil, nil)

var integrationRuntimeNodesDelete* = Call_IntegrationRuntimeNodesDelete_564557(
    name: "integrationRuntimeNodesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesDelete_564558, base: "",
    url: url_IntegrationRuntimeNodesDelete_564559, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesGetIpAddress_564585 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimeNodesGetIpAddress_564587(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesGetIpAddress_564586(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the IP address of self-hosted integration runtime node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   nodeName: JString (required)
  ##           : The integration runtime node name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564588 = path.getOrDefault("integrationRuntimeName")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = nil)
  if valid_564588 != nil:
    section.add "integrationRuntimeName", valid_564588
  var valid_564589 = path.getOrDefault("subscriptionId")
  valid_564589 = validateParameter(valid_564589, JString, required = true,
                                 default = nil)
  if valid_564589 != nil:
    section.add "subscriptionId", valid_564589
  var valid_564590 = path.getOrDefault("nodeName")
  valid_564590 = validateParameter(valid_564590, JString, required = true,
                                 default = nil)
  if valid_564590 != nil:
    section.add "nodeName", valid_564590
  var valid_564591 = path.getOrDefault("resourceGroupName")
  valid_564591 = validateParameter(valid_564591, JString, required = true,
                                 default = nil)
  if valid_564591 != nil:
    section.add "resourceGroupName", valid_564591
  var valid_564592 = path.getOrDefault("factoryName")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "factoryName", valid_564592
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564593 = query.getOrDefault("api-version")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "api-version", valid_564593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564594: Call_IntegrationRuntimeNodesGetIpAddress_564585;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IP address of self-hosted integration runtime node.
  ## 
  let valid = call_564594.validator(path, query, header, formData, body)
  let scheme = call_564594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564594.url(scheme.get, call_564594.host, call_564594.base,
                         call_564594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564594, url, valid)

proc call*(call_564595: Call_IntegrationRuntimeNodesGetIpAddress_564585;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; nodeName: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## integrationRuntimeNodesGetIpAddress
  ## Get the IP address of self-hosted integration runtime node.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   nodeName: string (required)
  ##           : The integration runtime node name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564596 = newJObject()
  var query_564597 = newJObject()
  add(query_564597, "api-version", newJString(apiVersion))
  add(path_564596, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564596, "subscriptionId", newJString(subscriptionId))
  add(path_564596, "nodeName", newJString(nodeName))
  add(path_564596, "resourceGroupName", newJString(resourceGroupName))
  add(path_564596, "factoryName", newJString(factoryName))
  result = call_564595.call(path_564596, query_564597, nil, nil, nil)

var integrationRuntimeNodesGetIpAddress* = Call_IntegrationRuntimeNodesGetIpAddress_564585(
    name: "integrationRuntimeNodesGetIpAddress", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}/ipAddress",
    validator: validate_IntegrationRuntimeNodesGetIpAddress_564586, base: "",
    url: url_IntegrationRuntimeNodesGetIpAddress_564587, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeObjectMetadataRefresh_564598 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimeObjectMetadataRefresh_564600(protocol: Scheme;
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

proc validate_IntegrationRuntimeObjectMetadataRefresh_564599(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Refresh a SSIS integration runtime object metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564601 = path.getOrDefault("integrationRuntimeName")
  valid_564601 = validateParameter(valid_564601, JString, required = true,
                                 default = nil)
  if valid_564601 != nil:
    section.add "integrationRuntimeName", valid_564601
  var valid_564602 = path.getOrDefault("subscriptionId")
  valid_564602 = validateParameter(valid_564602, JString, required = true,
                                 default = nil)
  if valid_564602 != nil:
    section.add "subscriptionId", valid_564602
  var valid_564603 = path.getOrDefault("resourceGroupName")
  valid_564603 = validateParameter(valid_564603, JString, required = true,
                                 default = nil)
  if valid_564603 != nil:
    section.add "resourceGroupName", valid_564603
  var valid_564604 = path.getOrDefault("factoryName")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "factoryName", valid_564604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564605 = query.getOrDefault("api-version")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "api-version", valid_564605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564606: Call_IntegrationRuntimeObjectMetadataRefresh_564598;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refresh a SSIS integration runtime object metadata.
  ## 
  let valid = call_564606.validator(path, query, header, formData, body)
  let scheme = call_564606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564606.url(scheme.get, call_564606.host, call_564606.base,
                         call_564606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564606, url, valid)

proc call*(call_564607: Call_IntegrationRuntimeObjectMetadataRefresh_564598;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimeObjectMetadataRefresh
  ## Refresh a SSIS integration runtime object metadata.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564608 = newJObject()
  var query_564609 = newJObject()
  add(query_564609, "api-version", newJString(apiVersion))
  add(path_564608, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564608, "subscriptionId", newJString(subscriptionId))
  add(path_564608, "resourceGroupName", newJString(resourceGroupName))
  add(path_564608, "factoryName", newJString(factoryName))
  result = call_564607.call(path_564608, query_564609, nil, nil, nil)

var integrationRuntimeObjectMetadataRefresh* = Call_IntegrationRuntimeObjectMetadataRefresh_564598(
    name: "integrationRuntimeObjectMetadataRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/refreshObjectMetadata",
    validator: validate_IntegrationRuntimeObjectMetadataRefresh_564599, base: "",
    url: url_IntegrationRuntimeObjectMetadataRefresh_564600,
    schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRegenerateAuthKey_564610 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesRegenerateAuthKey_564612(protocol: Scheme;
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

proc validate_IntegrationRuntimesRegenerateAuthKey_564611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the authentication key for an integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564613 = path.getOrDefault("integrationRuntimeName")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "integrationRuntimeName", valid_564613
  var valid_564614 = path.getOrDefault("subscriptionId")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "subscriptionId", valid_564614
  var valid_564615 = path.getOrDefault("resourceGroupName")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "resourceGroupName", valid_564615
  var valid_564616 = path.getOrDefault("factoryName")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "factoryName", valid_564616
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564617 = query.getOrDefault("api-version")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "api-version", valid_564617
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

proc call*(call_564619: Call_IntegrationRuntimesRegenerateAuthKey_564610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the authentication key for an integration runtime.
  ## 
  let valid = call_564619.validator(path, query, header, formData, body)
  let scheme = call_564619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564619.url(scheme.get, call_564619.host, call_564619.base,
                         call_564619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564619, url, valid)

proc call*(call_564620: Call_IntegrationRuntimesRegenerateAuthKey_564610;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; regenerateKeyParameters: JsonNode;
          resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesRegenerateAuthKey
  ## Regenerates the authentication key for an integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   regenerateKeyParameters: JObject (required)
  ##                          : The parameters for regenerating integration runtime authentication key.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564621 = newJObject()
  var query_564622 = newJObject()
  var body_564623 = newJObject()
  add(query_564622, "api-version", newJString(apiVersion))
  add(path_564621, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564621, "subscriptionId", newJString(subscriptionId))
  if regenerateKeyParameters != nil:
    body_564623 = regenerateKeyParameters
  add(path_564621, "resourceGroupName", newJString(resourceGroupName))
  add(path_564621, "factoryName", newJString(factoryName))
  result = call_564620.call(path_564621, query_564622, nil, nil, body_564623)

var integrationRuntimesRegenerateAuthKey* = Call_IntegrationRuntimesRegenerateAuthKey_564610(
    name: "integrationRuntimesRegenerateAuthKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/regenerateAuthKey",
    validator: validate_IntegrationRuntimesRegenerateAuthKey_564611, base: "",
    url: url_IntegrationRuntimesRegenerateAuthKey_564612, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRemoveLinks_564624 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesRemoveLinks_564626(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesRemoveLinks_564625(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove all linked integration runtimes under specific data factory in a self-hosted integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564627 = path.getOrDefault("integrationRuntimeName")
  valid_564627 = validateParameter(valid_564627, JString, required = true,
                                 default = nil)
  if valid_564627 != nil:
    section.add "integrationRuntimeName", valid_564627
  var valid_564628 = path.getOrDefault("subscriptionId")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "subscriptionId", valid_564628
  var valid_564629 = path.getOrDefault("resourceGroupName")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "resourceGroupName", valid_564629
  var valid_564630 = path.getOrDefault("factoryName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "factoryName", valid_564630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564631 = query.getOrDefault("api-version")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "api-version", valid_564631
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

proc call*(call_564633: Call_IntegrationRuntimesRemoveLinks_564624; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove all linked integration runtimes under specific data factory in a self-hosted integration runtime.
  ## 
  let valid = call_564633.validator(path, query, header, formData, body)
  let scheme = call_564633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564633.url(scheme.get, call_564633.host, call_564633.base,
                         call_564633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564633, url, valid)

proc call*(call_564634: Call_IntegrationRuntimesRemoveLinks_564624;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string;
          linkedIntegrationRuntimeRequest: JsonNode; factoryName: string): Recallable =
  ## integrationRuntimesRemoveLinks
  ## Remove all linked integration runtimes under specific data factory in a self-hosted integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   linkedIntegrationRuntimeRequest: JObject (required)
  ##                                  : The data factory name for the linked integration runtime.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564635 = newJObject()
  var query_564636 = newJObject()
  var body_564637 = newJObject()
  add(query_564636, "api-version", newJString(apiVersion))
  add(path_564635, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564635, "subscriptionId", newJString(subscriptionId))
  add(path_564635, "resourceGroupName", newJString(resourceGroupName))
  if linkedIntegrationRuntimeRequest != nil:
    body_564637 = linkedIntegrationRuntimeRequest
  add(path_564635, "factoryName", newJString(factoryName))
  result = call_564634.call(path_564635, query_564636, nil, nil, body_564637)

var integrationRuntimesRemoveLinks* = Call_IntegrationRuntimesRemoveLinks_564624(
    name: "integrationRuntimesRemoveLinks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/removeLinks",
    validator: validate_IntegrationRuntimesRemoveLinks_564625, base: "",
    url: url_IntegrationRuntimesRemoveLinks_564626, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStart_564638 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesStart_564640(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesStart_564639(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a ManagedReserved type integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564641 = path.getOrDefault("integrationRuntimeName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "integrationRuntimeName", valid_564641
  var valid_564642 = path.getOrDefault("subscriptionId")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "subscriptionId", valid_564642
  var valid_564643 = path.getOrDefault("resourceGroupName")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "resourceGroupName", valid_564643
  var valid_564644 = path.getOrDefault("factoryName")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "factoryName", valid_564644
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564645 = query.getOrDefault("api-version")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "api-version", valid_564645
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564646: Call_IntegrationRuntimesStart_564638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a ManagedReserved type integration runtime.
  ## 
  let valid = call_564646.validator(path, query, header, formData, body)
  let scheme = call_564646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564646.url(scheme.get, call_564646.host, call_564646.base,
                         call_564646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564646, url, valid)

proc call*(call_564647: Call_IntegrationRuntimesStart_564638; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesStart
  ## Starts a ManagedReserved type integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564648 = newJObject()
  var query_564649 = newJObject()
  add(query_564649, "api-version", newJString(apiVersion))
  add(path_564648, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564648, "subscriptionId", newJString(subscriptionId))
  add(path_564648, "resourceGroupName", newJString(resourceGroupName))
  add(path_564648, "factoryName", newJString(factoryName))
  result = call_564647.call(path_564648, query_564649, nil, nil, nil)

var integrationRuntimesStart* = Call_IntegrationRuntimesStart_564638(
    name: "integrationRuntimesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/start",
    validator: validate_IntegrationRuntimesStart_564639, base: "",
    url: url_IntegrationRuntimesStart_564640, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStop_564650 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesStop_564652(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationRuntimesStop_564651(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a ManagedReserved type integration runtime.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564653 = path.getOrDefault("integrationRuntimeName")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "integrationRuntimeName", valid_564653
  var valid_564654 = path.getOrDefault("subscriptionId")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "subscriptionId", valid_564654
  var valid_564655 = path.getOrDefault("resourceGroupName")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "resourceGroupName", valid_564655
  var valid_564656 = path.getOrDefault("factoryName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "factoryName", valid_564656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564657 = query.getOrDefault("api-version")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "api-version", valid_564657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564658: Call_IntegrationRuntimesStop_564650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a ManagedReserved type integration runtime.
  ## 
  let valid = call_564658.validator(path, query, header, formData, body)
  let scheme = call_564658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564658.url(scheme.get, call_564658.host, call_564658.base,
                         call_564658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564658, url, valid)

proc call*(call_564659: Call_IntegrationRuntimesStop_564650; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesStop
  ## Stops a ManagedReserved type integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564660 = newJObject()
  var query_564661 = newJObject()
  add(query_564661, "api-version", newJString(apiVersion))
  add(path_564660, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564660, "subscriptionId", newJString(subscriptionId))
  add(path_564660, "resourceGroupName", newJString(resourceGroupName))
  add(path_564660, "factoryName", newJString(factoryName))
  result = call_564659.call(path_564660, query_564661, nil, nil, nil)

var integrationRuntimesStop* = Call_IntegrationRuntimesStop_564650(
    name: "integrationRuntimesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/stop",
    validator: validate_IntegrationRuntimesStop_564651, base: "",
    url: url_IntegrationRuntimesStop_564652, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesSyncCredentials_564662 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesSyncCredentials_564664(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesSyncCredentials_564663(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564665 = path.getOrDefault("integrationRuntimeName")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "integrationRuntimeName", valid_564665
  var valid_564666 = path.getOrDefault("subscriptionId")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "subscriptionId", valid_564666
  var valid_564667 = path.getOrDefault("resourceGroupName")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "resourceGroupName", valid_564667
  var valid_564668 = path.getOrDefault("factoryName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "factoryName", valid_564668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564669 = query.getOrDefault("api-version")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "api-version", valid_564669
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564670: Call_IntegrationRuntimesSyncCredentials_564662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ## 
  let valid = call_564670.validator(path, query, header, formData, body)
  let scheme = call_564670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564670.url(scheme.get, call_564670.host, call_564670.base,
                         call_564670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564670, url, valid)

proc call*(call_564671: Call_IntegrationRuntimesSyncCredentials_564662;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesSyncCredentials
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564672 = newJObject()
  var query_564673 = newJObject()
  add(query_564673, "api-version", newJString(apiVersion))
  add(path_564672, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564672, "subscriptionId", newJString(subscriptionId))
  add(path_564672, "resourceGroupName", newJString(resourceGroupName))
  add(path_564672, "factoryName", newJString(factoryName))
  result = call_564671.call(path_564672, query_564673, nil, nil, nil)

var integrationRuntimesSyncCredentials* = Call_IntegrationRuntimesSyncCredentials_564662(
    name: "integrationRuntimesSyncCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/syncCredentials",
    validator: validate_IntegrationRuntimesSyncCredentials_564663, base: "",
    url: url_IntegrationRuntimesSyncCredentials_564664, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpgrade_564674 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesUpgrade_564676(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesUpgrade_564675(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   integrationRuntimeName: JString (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `integrationRuntimeName` field"
  var valid_564677 = path.getOrDefault("integrationRuntimeName")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "integrationRuntimeName", valid_564677
  var valid_564678 = path.getOrDefault("subscriptionId")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "subscriptionId", valid_564678
  var valid_564679 = path.getOrDefault("resourceGroupName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "resourceGroupName", valid_564679
  var valid_564680 = path.getOrDefault("factoryName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "factoryName", valid_564680
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564681 = query.getOrDefault("api-version")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "api-version", valid_564681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564682: Call_IntegrationRuntimesUpgrade_564674; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ## 
  let valid = call_564682.validator(path, query, header, formData, body)
  let scheme = call_564682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564682.url(scheme.get, call_564682.host, call_564682.base,
                         call_564682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564682, url, valid)

proc call*(call_564683: Call_IntegrationRuntimesUpgrade_564674; apiVersion: string;
          integrationRuntimeName: string; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## integrationRuntimesUpgrade
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564684 = newJObject()
  var query_564685 = newJObject()
  add(query_564685, "api-version", newJString(apiVersion))
  add(path_564684, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564684, "subscriptionId", newJString(subscriptionId))
  add(path_564684, "resourceGroupName", newJString(resourceGroupName))
  add(path_564684, "factoryName", newJString(factoryName))
  result = call_564683.call(path_564684, query_564685, nil, nil, nil)

var integrationRuntimesUpgrade* = Call_IntegrationRuntimesUpgrade_564674(
    name: "integrationRuntimesUpgrade", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/upgrade",
    validator: validate_IntegrationRuntimesUpgrade_564675, base: "",
    url: url_IntegrationRuntimesUpgrade_564676, schemes: {Scheme.Https})
type
  Call_LinkedServicesListByFactory_564686 = ref object of OpenApiRestCall_563566
proc url_LinkedServicesListByFactory_564688(protocol: Scheme; host: string;
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

proc validate_LinkedServicesListByFactory_564687(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists linked services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564689 = path.getOrDefault("subscriptionId")
  valid_564689 = validateParameter(valid_564689, JString, required = true,
                                 default = nil)
  if valid_564689 != nil:
    section.add "subscriptionId", valid_564689
  var valid_564690 = path.getOrDefault("resourceGroupName")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "resourceGroupName", valid_564690
  var valid_564691 = path.getOrDefault("factoryName")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "factoryName", valid_564691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564692 = query.getOrDefault("api-version")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "api-version", valid_564692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564693: Call_LinkedServicesListByFactory_564686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists linked services.
  ## 
  let valid = call_564693.validator(path, query, header, formData, body)
  let scheme = call_564693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564693.url(scheme.get, call_564693.host, call_564693.base,
                         call_564693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564693, url, valid)

proc call*(call_564694: Call_LinkedServicesListByFactory_564686;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## linkedServicesListByFactory
  ## Lists linked services.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564695 = newJObject()
  var query_564696 = newJObject()
  add(query_564696, "api-version", newJString(apiVersion))
  add(path_564695, "subscriptionId", newJString(subscriptionId))
  add(path_564695, "resourceGroupName", newJString(resourceGroupName))
  add(path_564695, "factoryName", newJString(factoryName))
  result = call_564694.call(path_564695, query_564696, nil, nil, nil)

var linkedServicesListByFactory* = Call_LinkedServicesListByFactory_564686(
    name: "linkedServicesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices",
    validator: validate_LinkedServicesListByFactory_564687, base: "",
    url: url_LinkedServicesListByFactory_564688, schemes: {Scheme.Https})
type
  Call_LinkedServicesCreateOrUpdate_564710 = ref object of OpenApiRestCall_563566
proc url_LinkedServicesCreateOrUpdate_564712(protocol: Scheme; host: string;
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

proc validate_LinkedServicesCreateOrUpdate_564711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a linked service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   linkedServiceName: JString (required)
  ##                    : The linked service name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564713 = path.getOrDefault("subscriptionId")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "subscriptionId", valid_564713
  var valid_564714 = path.getOrDefault("resourceGroupName")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "resourceGroupName", valid_564714
  var valid_564715 = path.getOrDefault("factoryName")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "factoryName", valid_564715
  var valid_564716 = path.getOrDefault("linkedServiceName")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "linkedServiceName", valid_564716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564717 = query.getOrDefault("api-version")
  valid_564717 = validateParameter(valid_564717, JString, required = true,
                                 default = nil)
  if valid_564717 != nil:
    section.add "api-version", valid_564717
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the linkedService entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564718 = header.getOrDefault("If-Match")
  valid_564718 = validateParameter(valid_564718, JString, required = false,
                                 default = nil)
  if valid_564718 != nil:
    section.add "If-Match", valid_564718
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

proc call*(call_564720: Call_LinkedServicesCreateOrUpdate_564710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a linked service.
  ## 
  let valid = call_564720.validator(path, query, header, formData, body)
  let scheme = call_564720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564720.url(scheme.get, call_564720.host, call_564720.base,
                         call_564720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564720, url, valid)

proc call*(call_564721: Call_LinkedServicesCreateOrUpdate_564710;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string; linkedServiceName: string; linkedService: JsonNode): Recallable =
  ## linkedServicesCreateOrUpdate
  ## Creates or updates a linked service.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   linkedServiceName: string (required)
  ##                    : The linked service name.
  ##   linkedService: JObject (required)
  ##                : Linked service resource definition.
  var path_564722 = newJObject()
  var query_564723 = newJObject()
  var body_564724 = newJObject()
  add(query_564723, "api-version", newJString(apiVersion))
  add(path_564722, "subscriptionId", newJString(subscriptionId))
  add(path_564722, "resourceGroupName", newJString(resourceGroupName))
  add(path_564722, "factoryName", newJString(factoryName))
  add(path_564722, "linkedServiceName", newJString(linkedServiceName))
  if linkedService != nil:
    body_564724 = linkedService
  result = call_564721.call(path_564722, query_564723, nil, nil, body_564724)

var linkedServicesCreateOrUpdate* = Call_LinkedServicesCreateOrUpdate_564710(
    name: "linkedServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesCreateOrUpdate_564711, base: "",
    url: url_LinkedServicesCreateOrUpdate_564712, schemes: {Scheme.Https})
type
  Call_LinkedServicesGet_564697 = ref object of OpenApiRestCall_563566
proc url_LinkedServicesGet_564699(protocol: Scheme; host: string; base: string;
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

proc validate_LinkedServicesGet_564698(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a linked service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   linkedServiceName: JString (required)
  ##                    : The linked service name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564700 = path.getOrDefault("subscriptionId")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "subscriptionId", valid_564700
  var valid_564701 = path.getOrDefault("resourceGroupName")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "resourceGroupName", valid_564701
  var valid_564702 = path.getOrDefault("factoryName")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = nil)
  if valid_564702 != nil:
    section.add "factoryName", valid_564702
  var valid_564703 = path.getOrDefault("linkedServiceName")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "linkedServiceName", valid_564703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564704 = query.getOrDefault("api-version")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "api-version", valid_564704
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the linked service entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_564705 = header.getOrDefault("If-None-Match")
  valid_564705 = validateParameter(valid_564705, JString, required = false,
                                 default = nil)
  if valid_564705 != nil:
    section.add "If-None-Match", valid_564705
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564706: Call_LinkedServicesGet_564697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a linked service.
  ## 
  let valid = call_564706.validator(path, query, header, formData, body)
  let scheme = call_564706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564706.url(scheme.get, call_564706.host, call_564706.base,
                         call_564706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564706, url, valid)

proc call*(call_564707: Call_LinkedServicesGet_564697; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string;
          linkedServiceName: string): Recallable =
  ## linkedServicesGet
  ## Gets a linked service.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   linkedServiceName: string (required)
  ##                    : The linked service name.
  var path_564708 = newJObject()
  var query_564709 = newJObject()
  add(query_564709, "api-version", newJString(apiVersion))
  add(path_564708, "subscriptionId", newJString(subscriptionId))
  add(path_564708, "resourceGroupName", newJString(resourceGroupName))
  add(path_564708, "factoryName", newJString(factoryName))
  add(path_564708, "linkedServiceName", newJString(linkedServiceName))
  result = call_564707.call(path_564708, query_564709, nil, nil, nil)

var linkedServicesGet* = Call_LinkedServicesGet_564697(name: "linkedServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesGet_564698, base: "",
    url: url_LinkedServicesGet_564699, schemes: {Scheme.Https})
type
  Call_LinkedServicesDelete_564725 = ref object of OpenApiRestCall_563566
proc url_LinkedServicesDelete_564727(protocol: Scheme; host: string; base: string;
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

proc validate_LinkedServicesDelete_564726(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a linked service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  ##   linkedServiceName: JString (required)
  ##                    : The linked service name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564728 = path.getOrDefault("subscriptionId")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "subscriptionId", valid_564728
  var valid_564729 = path.getOrDefault("resourceGroupName")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "resourceGroupName", valid_564729
  var valid_564730 = path.getOrDefault("factoryName")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "factoryName", valid_564730
  var valid_564731 = path.getOrDefault("linkedServiceName")
  valid_564731 = validateParameter(valid_564731, JString, required = true,
                                 default = nil)
  if valid_564731 != nil:
    section.add "linkedServiceName", valid_564731
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564732 = query.getOrDefault("api-version")
  valid_564732 = validateParameter(valid_564732, JString, required = true,
                                 default = nil)
  if valid_564732 != nil:
    section.add "api-version", valid_564732
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564733: Call_LinkedServicesDelete_564725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a linked service.
  ## 
  let valid = call_564733.validator(path, query, header, formData, body)
  let scheme = call_564733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564733.url(scheme.get, call_564733.host, call_564733.base,
                         call_564733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564733, url, valid)

proc call*(call_564734: Call_LinkedServicesDelete_564725; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string;
          linkedServiceName: string): Recallable =
  ## linkedServicesDelete
  ## Deletes a linked service.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   linkedServiceName: string (required)
  ##                    : The linked service name.
  var path_564735 = newJObject()
  var query_564736 = newJObject()
  add(query_564736, "api-version", newJString(apiVersion))
  add(path_564735, "subscriptionId", newJString(subscriptionId))
  add(path_564735, "resourceGroupName", newJString(resourceGroupName))
  add(path_564735, "factoryName", newJString(factoryName))
  add(path_564735, "linkedServiceName", newJString(linkedServiceName))
  result = call_564734.call(path_564735, query_564736, nil, nil, nil)

var linkedServicesDelete* = Call_LinkedServicesDelete_564725(
    name: "linkedServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesDelete_564726, base: "",
    url: url_LinkedServicesDelete_564727, schemes: {Scheme.Https})
type
  Call_PipelineRunsGet_564737 = ref object of OpenApiRestCall_563566
proc url_PipelineRunsGet_564739(protocol: Scheme; host: string; base: string;
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

proc validate_PipelineRunsGet_564738(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a pipeline run by its run ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runId` field"
  var valid_564740 = path.getOrDefault("runId")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "runId", valid_564740
  var valid_564741 = path.getOrDefault("subscriptionId")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "subscriptionId", valid_564741
  var valid_564742 = path.getOrDefault("resourceGroupName")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "resourceGroupName", valid_564742
  var valid_564743 = path.getOrDefault("factoryName")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "factoryName", valid_564743
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564744 = query.getOrDefault("api-version")
  valid_564744 = validateParameter(valid_564744, JString, required = true,
                                 default = nil)
  if valid_564744 != nil:
    section.add "api-version", valid_564744
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564745: Call_PipelineRunsGet_564737; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a pipeline run by its run ID.
  ## 
  let valid = call_564745.validator(path, query, header, formData, body)
  let scheme = call_564745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564745.url(scheme.get, call_564745.host, call_564745.base,
                         call_564745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564745, url, valid)

proc call*(call_564746: Call_PipelineRunsGet_564737; runId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## pipelineRunsGet
  ## Get a pipeline run by its run ID.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564747 = newJObject()
  var query_564748 = newJObject()
  add(path_564747, "runId", newJString(runId))
  add(query_564748, "api-version", newJString(apiVersion))
  add(path_564747, "subscriptionId", newJString(subscriptionId))
  add(path_564747, "resourceGroupName", newJString(resourceGroupName))
  add(path_564747, "factoryName", newJString(factoryName))
  result = call_564746.call(path_564747, query_564748, nil, nil, nil)

var pipelineRunsGet* = Call_PipelineRunsGet_564737(name: "pipelineRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}",
    validator: validate_PipelineRunsGet_564738, base: "", url: url_PipelineRunsGet_564739,
    schemes: {Scheme.Https})
type
  Call_PipelineRunsCancel_564749 = ref object of OpenApiRestCall_563566
proc url_PipelineRunsCancel_564751(protocol: Scheme; host: string; base: string;
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

proc validate_PipelineRunsCancel_564750(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Cancel a pipeline run by its run ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runId` field"
  var valid_564752 = path.getOrDefault("runId")
  valid_564752 = validateParameter(valid_564752, JString, required = true,
                                 default = nil)
  if valid_564752 != nil:
    section.add "runId", valid_564752
  var valid_564753 = path.getOrDefault("subscriptionId")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "subscriptionId", valid_564753
  var valid_564754 = path.getOrDefault("resourceGroupName")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "resourceGroupName", valid_564754
  var valid_564755 = path.getOrDefault("factoryName")
  valid_564755 = validateParameter(valid_564755, JString, required = true,
                                 default = nil)
  if valid_564755 != nil:
    section.add "factoryName", valid_564755
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   isRecursive: JBool
  ##              : If true, cancel all the Child pipelines that are triggered by the current pipeline.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564756 = query.getOrDefault("api-version")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = nil)
  if valid_564756 != nil:
    section.add "api-version", valid_564756
  var valid_564757 = query.getOrDefault("isRecursive")
  valid_564757 = validateParameter(valid_564757, JBool, required = false, default = nil)
  if valid_564757 != nil:
    section.add "isRecursive", valid_564757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564758: Call_PipelineRunsCancel_564749; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a pipeline run by its run ID.
  ## 
  let valid = call_564758.validator(path, query, header, formData, body)
  let scheme = call_564758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564758.url(scheme.get, call_564758.host, call_564758.base,
                         call_564758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564758, url, valid)

proc call*(call_564759: Call_PipelineRunsCancel_564749; runId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string; isRecursive: bool = false): Recallable =
  ## pipelineRunsCancel
  ## Cancel a pipeline run by its run ID.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   isRecursive: bool
  ##              : If true, cancel all the Child pipelines that are triggered by the current pipeline.
  var path_564760 = newJObject()
  var query_564761 = newJObject()
  add(path_564760, "runId", newJString(runId))
  add(query_564761, "api-version", newJString(apiVersion))
  add(path_564760, "subscriptionId", newJString(subscriptionId))
  add(path_564760, "resourceGroupName", newJString(resourceGroupName))
  add(path_564760, "factoryName", newJString(factoryName))
  add(query_564761, "isRecursive", newJBool(isRecursive))
  result = call_564759.call(path_564760, query_564761, nil, nil, nil)

var pipelineRunsCancel* = Call_PipelineRunsCancel_564749(
    name: "pipelineRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}/cancel",
    validator: validate_PipelineRunsCancel_564750, base: "",
    url: url_PipelineRunsCancel_564751, schemes: {Scheme.Https})
type
  Call_ActivityRunsQueryByPipelineRun_564762 = ref object of OpenApiRestCall_563566
proc url_ActivityRunsQueryByPipelineRun_564764(protocol: Scheme; host: string;
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

proc validate_ActivityRunsQueryByPipelineRun_564763(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query activity runs based on input filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runId` field"
  var valid_564765 = path.getOrDefault("runId")
  valid_564765 = validateParameter(valid_564765, JString, required = true,
                                 default = nil)
  if valid_564765 != nil:
    section.add "runId", valid_564765
  var valid_564766 = path.getOrDefault("subscriptionId")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "subscriptionId", valid_564766
  var valid_564767 = path.getOrDefault("resourceGroupName")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = nil)
  if valid_564767 != nil:
    section.add "resourceGroupName", valid_564767
  var valid_564768 = path.getOrDefault("factoryName")
  valid_564768 = validateParameter(valid_564768, JString, required = true,
                                 default = nil)
  if valid_564768 != nil:
    section.add "factoryName", valid_564768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564769 = query.getOrDefault("api-version")
  valid_564769 = validateParameter(valid_564769, JString, required = true,
                                 default = nil)
  if valid_564769 != nil:
    section.add "api-version", valid_564769
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

proc call*(call_564771: Call_ActivityRunsQueryByPipelineRun_564762; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query activity runs based on input filter conditions.
  ## 
  let valid = call_564771.validator(path, query, header, formData, body)
  let scheme = call_564771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564771.url(scheme.get, call_564771.host, call_564771.base,
                         call_564771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564771, url, valid)

proc call*(call_564772: Call_ActivityRunsQueryByPipelineRun_564762; runId: string;
          apiVersion: string; filterParameters: JsonNode; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## activityRunsQueryByPipelineRun
  ## Query activity runs based on input filter conditions.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the activity runs.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564773 = newJObject()
  var query_564774 = newJObject()
  var body_564775 = newJObject()
  add(path_564773, "runId", newJString(runId))
  add(query_564774, "api-version", newJString(apiVersion))
  if filterParameters != nil:
    body_564775 = filterParameters
  add(path_564773, "subscriptionId", newJString(subscriptionId))
  add(path_564773, "resourceGroupName", newJString(resourceGroupName))
  add(path_564773, "factoryName", newJString(factoryName))
  result = call_564772.call(path_564773, query_564774, nil, nil, body_564775)

var activityRunsQueryByPipelineRun* = Call_ActivityRunsQueryByPipelineRun_564762(
    name: "activityRunsQueryByPipelineRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}/queryActivityruns",
    validator: validate_ActivityRunsQueryByPipelineRun_564763, base: "",
    url: url_ActivityRunsQueryByPipelineRun_564764, schemes: {Scheme.Https})
type
  Call_PipelinesListByFactory_564776 = ref object of OpenApiRestCall_563566
proc url_PipelinesListByFactory_564778(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesListByFactory_564777(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists pipelines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564779 = path.getOrDefault("subscriptionId")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "subscriptionId", valid_564779
  var valid_564780 = path.getOrDefault("resourceGroupName")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "resourceGroupName", valid_564780
  var valid_564781 = path.getOrDefault("factoryName")
  valid_564781 = validateParameter(valid_564781, JString, required = true,
                                 default = nil)
  if valid_564781 != nil:
    section.add "factoryName", valid_564781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564782 = query.getOrDefault("api-version")
  valid_564782 = validateParameter(valid_564782, JString, required = true,
                                 default = nil)
  if valid_564782 != nil:
    section.add "api-version", valid_564782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564783: Call_PipelinesListByFactory_564776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  let valid = call_564783.validator(path, query, header, formData, body)
  let scheme = call_564783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564783.url(scheme.get, call_564783.host, call_564783.base,
                         call_564783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564783, url, valid)

proc call*(call_564784: Call_PipelinesListByFactory_564776; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## pipelinesListByFactory
  ## Lists pipelines.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564785 = newJObject()
  var query_564786 = newJObject()
  add(query_564786, "api-version", newJString(apiVersion))
  add(path_564785, "subscriptionId", newJString(subscriptionId))
  add(path_564785, "resourceGroupName", newJString(resourceGroupName))
  add(path_564785, "factoryName", newJString(factoryName))
  result = call_564784.call(path_564785, query_564786, nil, nil, nil)

var pipelinesListByFactory* = Call_PipelinesListByFactory_564776(
    name: "pipelinesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines",
    validator: validate_PipelinesListByFactory_564777, base: "",
    url: url_PipelinesListByFactory_564778, schemes: {Scheme.Https})
type
  Call_PipelinesCreateOrUpdate_564800 = ref object of OpenApiRestCall_563566
proc url_PipelinesCreateOrUpdate_564802(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesCreateOrUpdate_564801(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564803 = path.getOrDefault("subscriptionId")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "subscriptionId", valid_564803
  var valid_564804 = path.getOrDefault("pipelineName")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "pipelineName", valid_564804
  var valid_564805 = path.getOrDefault("resourceGroupName")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "resourceGroupName", valid_564805
  var valid_564806 = path.getOrDefault("factoryName")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "factoryName", valid_564806
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564807 = query.getOrDefault("api-version")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = nil)
  if valid_564807 != nil:
    section.add "api-version", valid_564807
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the pipeline entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564808 = header.getOrDefault("If-Match")
  valid_564808 = validateParameter(valid_564808, JString, required = false,
                                 default = nil)
  if valid_564808 != nil:
    section.add "If-Match", valid_564808
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

proc call*(call_564810: Call_PipelinesCreateOrUpdate_564800; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a pipeline.
  ## 
  let valid = call_564810.validator(path, query, header, formData, body)
  let scheme = call_564810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564810.url(scheme.get, call_564810.host, call_564810.base,
                         call_564810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564810, url, valid)

proc call*(call_564811: Call_PipelinesCreateOrUpdate_564800; pipeline: JsonNode;
          apiVersion: string; subscriptionId: string; pipelineName: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## pipelinesCreateOrUpdate
  ## Creates or updates a pipeline.
  ##   pipeline: JObject (required)
  ##           : Pipeline resource definition.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564812 = newJObject()
  var query_564813 = newJObject()
  var body_564814 = newJObject()
  if pipeline != nil:
    body_564814 = pipeline
  add(query_564813, "api-version", newJString(apiVersion))
  add(path_564812, "subscriptionId", newJString(subscriptionId))
  add(path_564812, "pipelineName", newJString(pipelineName))
  add(path_564812, "resourceGroupName", newJString(resourceGroupName))
  add(path_564812, "factoryName", newJString(factoryName))
  result = call_564811.call(path_564812, query_564813, nil, nil, body_564814)

var pipelinesCreateOrUpdate* = Call_PipelinesCreateOrUpdate_564800(
    name: "pipelinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesCreateOrUpdate_564801, base: "",
    url: url_PipelinesCreateOrUpdate_564802, schemes: {Scheme.Https})
type
  Call_PipelinesGet_564787 = ref object of OpenApiRestCall_563566
proc url_PipelinesGet_564789(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesGet_564788(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564790 = path.getOrDefault("subscriptionId")
  valid_564790 = validateParameter(valid_564790, JString, required = true,
                                 default = nil)
  if valid_564790 != nil:
    section.add "subscriptionId", valid_564790
  var valid_564791 = path.getOrDefault("pipelineName")
  valid_564791 = validateParameter(valid_564791, JString, required = true,
                                 default = nil)
  if valid_564791 != nil:
    section.add "pipelineName", valid_564791
  var valid_564792 = path.getOrDefault("resourceGroupName")
  valid_564792 = validateParameter(valid_564792, JString, required = true,
                                 default = nil)
  if valid_564792 != nil:
    section.add "resourceGroupName", valid_564792
  var valid_564793 = path.getOrDefault("factoryName")
  valid_564793 = validateParameter(valid_564793, JString, required = true,
                                 default = nil)
  if valid_564793 != nil:
    section.add "factoryName", valid_564793
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564794 = query.getOrDefault("api-version")
  valid_564794 = validateParameter(valid_564794, JString, required = true,
                                 default = nil)
  if valid_564794 != nil:
    section.add "api-version", valid_564794
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the pipeline entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_564795 = header.getOrDefault("If-None-Match")
  valid_564795 = validateParameter(valid_564795, JString, required = false,
                                 default = nil)
  if valid_564795 != nil:
    section.add "If-None-Match", valid_564795
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564796: Call_PipelinesGet_564787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a pipeline.
  ## 
  let valid = call_564796.validator(path, query, header, formData, body)
  let scheme = call_564796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564796.url(scheme.get, call_564796.host, call_564796.base,
                         call_564796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564796, url, valid)

proc call*(call_564797: Call_PipelinesGet_564787; apiVersion: string;
          subscriptionId: string; pipelineName: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## pipelinesGet
  ## Gets a pipeline.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564798 = newJObject()
  var query_564799 = newJObject()
  add(query_564799, "api-version", newJString(apiVersion))
  add(path_564798, "subscriptionId", newJString(subscriptionId))
  add(path_564798, "pipelineName", newJString(pipelineName))
  add(path_564798, "resourceGroupName", newJString(resourceGroupName))
  add(path_564798, "factoryName", newJString(factoryName))
  result = call_564797.call(path_564798, query_564799, nil, nil, nil)

var pipelinesGet* = Call_PipelinesGet_564787(name: "pipelinesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesGet_564788, base: "", url: url_PipelinesGet_564789,
    schemes: {Scheme.Https})
type
  Call_PipelinesDelete_564815 = ref object of OpenApiRestCall_563566
proc url_PipelinesDelete_564817(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesDelete_564816(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564818 = path.getOrDefault("subscriptionId")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "subscriptionId", valid_564818
  var valid_564819 = path.getOrDefault("pipelineName")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "pipelineName", valid_564819
  var valid_564820 = path.getOrDefault("resourceGroupName")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = nil)
  if valid_564820 != nil:
    section.add "resourceGroupName", valid_564820
  var valid_564821 = path.getOrDefault("factoryName")
  valid_564821 = validateParameter(valid_564821, JString, required = true,
                                 default = nil)
  if valid_564821 != nil:
    section.add "factoryName", valid_564821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564822 = query.getOrDefault("api-version")
  valid_564822 = validateParameter(valid_564822, JString, required = true,
                                 default = nil)
  if valid_564822 != nil:
    section.add "api-version", valid_564822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564823: Call_PipelinesDelete_564815; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline.
  ## 
  let valid = call_564823.validator(path, query, header, formData, body)
  let scheme = call_564823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564823.url(scheme.get, call_564823.host, call_564823.base,
                         call_564823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564823, url, valid)

proc call*(call_564824: Call_PipelinesDelete_564815; apiVersion: string;
          subscriptionId: string; pipelineName: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## pipelinesDelete
  ## Deletes a pipeline.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564825 = newJObject()
  var query_564826 = newJObject()
  add(query_564826, "api-version", newJString(apiVersion))
  add(path_564825, "subscriptionId", newJString(subscriptionId))
  add(path_564825, "pipelineName", newJString(pipelineName))
  add(path_564825, "resourceGroupName", newJString(resourceGroupName))
  add(path_564825, "factoryName", newJString(factoryName))
  result = call_564824.call(path_564825, query_564826, nil, nil, nil)

var pipelinesDelete* = Call_PipelinesDelete_564815(name: "pipelinesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesDelete_564816, base: "", url: url_PipelinesDelete_564817,
    schemes: {Scheme.Https})
type
  Call_PipelinesCreateRun_564827 = ref object of OpenApiRestCall_563566
proc url_PipelinesCreateRun_564829(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesCreateRun_564828(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates a run of a pipeline.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   pipelineName: JString (required)
  ##               : The pipeline name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564830 = path.getOrDefault("subscriptionId")
  valid_564830 = validateParameter(valid_564830, JString, required = true,
                                 default = nil)
  if valid_564830 != nil:
    section.add "subscriptionId", valid_564830
  var valid_564831 = path.getOrDefault("pipelineName")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "pipelineName", valid_564831
  var valid_564832 = path.getOrDefault("resourceGroupName")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "resourceGroupName", valid_564832
  var valid_564833 = path.getOrDefault("factoryName")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = nil)
  if valid_564833 != nil:
    section.add "factoryName", valid_564833
  result.add "path", section
  ## parameters in `query` object:
  ##   referencePipelineRunId: JString
  ##                         : The pipeline run identifier. If run ID is specified the parameters of the specified run will be used to create a new run.
  ##   startActivityName: JString
  ##                    : In recovery mode, the rerun will start from this activity. If not specified, all activities will run.
  ##   api-version: JString (required)
  ##              : The API version.
  ##   isRecovery: JBool
  ##             : Recovery mode flag. If recovery mode is set to true, the specified referenced pipeline run and the new run will be grouped under the same groupId.
  section = newJObject()
  var valid_564834 = query.getOrDefault("referencePipelineRunId")
  valid_564834 = validateParameter(valid_564834, JString, required = false,
                                 default = nil)
  if valid_564834 != nil:
    section.add "referencePipelineRunId", valid_564834
  var valid_564835 = query.getOrDefault("startActivityName")
  valid_564835 = validateParameter(valid_564835, JString, required = false,
                                 default = nil)
  if valid_564835 != nil:
    section.add "startActivityName", valid_564835
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564836 = query.getOrDefault("api-version")
  valid_564836 = validateParameter(valid_564836, JString, required = true,
                                 default = nil)
  if valid_564836 != nil:
    section.add "api-version", valid_564836
  var valid_564837 = query.getOrDefault("isRecovery")
  valid_564837 = validateParameter(valid_564837, JBool, required = false, default = nil)
  if valid_564837 != nil:
    section.add "isRecovery", valid_564837
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

proc call*(call_564839: Call_PipelinesCreateRun_564827; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a run of a pipeline.
  ## 
  let valid = call_564839.validator(path, query, header, formData, body)
  let scheme = call_564839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564839.url(scheme.get, call_564839.host, call_564839.base,
                         call_564839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564839, url, valid)

proc call*(call_564840: Call_PipelinesCreateRun_564827; apiVersion: string;
          subscriptionId: string; pipelineName: string; resourceGroupName: string;
          factoryName: string; referencePipelineRunId: string = "";
          startActivityName: string = ""; isRecovery: bool = false;
          parameters: JsonNode = nil): Recallable =
  ## pipelinesCreateRun
  ## Creates a run of a pipeline.
  ##   referencePipelineRunId: string
  ##                         : The pipeline run identifier. If run ID is specified the parameters of the specified run will be used to create a new run.
  ##   startActivityName: string
  ##                    : In recovery mode, the rerun will start from this activity. If not specified, all activities will run.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   isRecovery: bool
  ##             : Recovery mode flag. If recovery mode is set to true, the specified referenced pipeline run and the new run will be grouped under the same groupId.
  ##   pipelineName: string (required)
  ##               : The pipeline name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   parameters: JObject
  ##             : Parameters of the pipeline run. These parameters will be used only if the runId is not specified.
  var path_564841 = newJObject()
  var query_564842 = newJObject()
  var body_564843 = newJObject()
  add(query_564842, "referencePipelineRunId", newJString(referencePipelineRunId))
  add(query_564842, "startActivityName", newJString(startActivityName))
  add(query_564842, "api-version", newJString(apiVersion))
  add(path_564841, "subscriptionId", newJString(subscriptionId))
  add(query_564842, "isRecovery", newJBool(isRecovery))
  add(path_564841, "pipelineName", newJString(pipelineName))
  add(path_564841, "resourceGroupName", newJString(resourceGroupName))
  add(path_564841, "factoryName", newJString(factoryName))
  if parameters != nil:
    body_564843 = parameters
  result = call_564840.call(path_564841, query_564842, nil, nil, body_564843)

var pipelinesCreateRun* = Call_PipelinesCreateRun_564827(
    name: "pipelinesCreateRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}/createRun",
    validator: validate_PipelinesCreateRun_564828, base: "",
    url: url_PipelinesCreateRun_564829, schemes: {Scheme.Https})
type
  Call_DataFlowDebugSessionQueryByFactory_564844 = ref object of OpenApiRestCall_563566
proc url_DataFlowDebugSessionQueryByFactory_564846(protocol: Scheme; host: string;
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

proc validate_DataFlowDebugSessionQueryByFactory_564845(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query all active data flow debug sessions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564847 = path.getOrDefault("subscriptionId")
  valid_564847 = validateParameter(valid_564847, JString, required = true,
                                 default = nil)
  if valid_564847 != nil:
    section.add "subscriptionId", valid_564847
  var valid_564848 = path.getOrDefault("resourceGroupName")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "resourceGroupName", valid_564848
  var valid_564849 = path.getOrDefault("factoryName")
  valid_564849 = validateParameter(valid_564849, JString, required = true,
                                 default = nil)
  if valid_564849 != nil:
    section.add "factoryName", valid_564849
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564850 = query.getOrDefault("api-version")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "api-version", valid_564850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564851: Call_DataFlowDebugSessionQueryByFactory_564844;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Query all active data flow debug sessions.
  ## 
  let valid = call_564851.validator(path, query, header, formData, body)
  let scheme = call_564851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564851.url(scheme.get, call_564851.host, call_564851.base,
                         call_564851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564851, url, valid)

proc call*(call_564852: Call_DataFlowDebugSessionQueryByFactory_564844;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## dataFlowDebugSessionQueryByFactory
  ## Query all active data flow debug sessions.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564853 = newJObject()
  var query_564854 = newJObject()
  add(query_564854, "api-version", newJString(apiVersion))
  add(path_564853, "subscriptionId", newJString(subscriptionId))
  add(path_564853, "resourceGroupName", newJString(resourceGroupName))
  add(path_564853, "factoryName", newJString(factoryName))
  result = call_564852.call(path_564853, query_564854, nil, nil, nil)

var dataFlowDebugSessionQueryByFactory* = Call_DataFlowDebugSessionQueryByFactory_564844(
    name: "dataFlowDebugSessionQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/queryDataFlowDebugSessions",
    validator: validate_DataFlowDebugSessionQueryByFactory_564845, base: "",
    url: url_DataFlowDebugSessionQueryByFactory_564846, schemes: {Scheme.Https})
type
  Call_PipelineRunsQueryByFactory_564855 = ref object of OpenApiRestCall_563566
proc url_PipelineRunsQueryByFactory_564857(protocol: Scheme; host: string;
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

proc validate_PipelineRunsQueryByFactory_564856(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query pipeline runs in the factory based on input filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564858 = path.getOrDefault("subscriptionId")
  valid_564858 = validateParameter(valid_564858, JString, required = true,
                                 default = nil)
  if valid_564858 != nil:
    section.add "subscriptionId", valid_564858
  var valid_564859 = path.getOrDefault("resourceGroupName")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "resourceGroupName", valid_564859
  var valid_564860 = path.getOrDefault("factoryName")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "factoryName", valid_564860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564861 = query.getOrDefault("api-version")
  valid_564861 = validateParameter(valid_564861, JString, required = true,
                                 default = nil)
  if valid_564861 != nil:
    section.add "api-version", valid_564861
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

proc call*(call_564863: Call_PipelineRunsQueryByFactory_564855; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query pipeline runs in the factory based on input filter conditions.
  ## 
  let valid = call_564863.validator(path, query, header, formData, body)
  let scheme = call_564863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564863.url(scheme.get, call_564863.host, call_564863.base,
                         call_564863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564863, url, valid)

proc call*(call_564864: Call_PipelineRunsQueryByFactory_564855; apiVersion: string;
          filterParameters: JsonNode; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## pipelineRunsQueryByFactory
  ## Query pipeline runs in the factory based on input filter conditions.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the pipeline run.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564865 = newJObject()
  var query_564866 = newJObject()
  var body_564867 = newJObject()
  add(query_564866, "api-version", newJString(apiVersion))
  if filterParameters != nil:
    body_564867 = filterParameters
  add(path_564865, "subscriptionId", newJString(subscriptionId))
  add(path_564865, "resourceGroupName", newJString(resourceGroupName))
  add(path_564865, "factoryName", newJString(factoryName))
  result = call_564864.call(path_564865, query_564866, nil, nil, body_564867)

var pipelineRunsQueryByFactory* = Call_PipelineRunsQueryByFactory_564855(
    name: "pipelineRunsQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/queryPipelineRuns",
    validator: validate_PipelineRunsQueryByFactory_564856, base: "",
    url: url_PipelineRunsQueryByFactory_564857, schemes: {Scheme.Https})
type
  Call_TriggerRunsQueryByFactory_564868 = ref object of OpenApiRestCall_563566
proc url_TriggerRunsQueryByFactory_564870(protocol: Scheme; host: string;
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

proc validate_TriggerRunsQueryByFactory_564869(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Query trigger runs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564871 = path.getOrDefault("subscriptionId")
  valid_564871 = validateParameter(valid_564871, JString, required = true,
                                 default = nil)
  if valid_564871 != nil:
    section.add "subscriptionId", valid_564871
  var valid_564872 = path.getOrDefault("resourceGroupName")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "resourceGroupName", valid_564872
  var valid_564873 = path.getOrDefault("factoryName")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "factoryName", valid_564873
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564874 = query.getOrDefault("api-version")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = nil)
  if valid_564874 != nil:
    section.add "api-version", valid_564874
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

proc call*(call_564876: Call_TriggerRunsQueryByFactory_564868; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query trigger runs.
  ## 
  let valid = call_564876.validator(path, query, header, formData, body)
  let scheme = call_564876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564876.url(scheme.get, call_564876.host, call_564876.base,
                         call_564876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564876, url, valid)

proc call*(call_564877: Call_TriggerRunsQueryByFactory_564868; apiVersion: string;
          filterParameters: JsonNode; subscriptionId: string;
          resourceGroupName: string; factoryName: string): Recallable =
  ## triggerRunsQueryByFactory
  ## Query trigger runs.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   filterParameters: JObject (required)
  ##                   : Parameters to filter the pipeline run.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564878 = newJObject()
  var query_564879 = newJObject()
  var body_564880 = newJObject()
  add(query_564879, "api-version", newJString(apiVersion))
  if filterParameters != nil:
    body_564880 = filterParameters
  add(path_564878, "subscriptionId", newJString(subscriptionId))
  add(path_564878, "resourceGroupName", newJString(resourceGroupName))
  add(path_564878, "factoryName", newJString(factoryName))
  result = call_564877.call(path_564878, query_564879, nil, nil, body_564880)

var triggerRunsQueryByFactory* = Call_TriggerRunsQueryByFactory_564868(
    name: "triggerRunsQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/queryTriggerRuns",
    validator: validate_TriggerRunsQueryByFactory_564869, base: "",
    url: url_TriggerRunsQueryByFactory_564870, schemes: {Scheme.Https})
type
  Call_TriggersListByFactory_564881 = ref object of OpenApiRestCall_563566
proc url_TriggersListByFactory_564883(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersListByFactory_564882(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists triggers.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564884 = path.getOrDefault("subscriptionId")
  valid_564884 = validateParameter(valid_564884, JString, required = true,
                                 default = nil)
  if valid_564884 != nil:
    section.add "subscriptionId", valid_564884
  var valid_564885 = path.getOrDefault("resourceGroupName")
  valid_564885 = validateParameter(valid_564885, JString, required = true,
                                 default = nil)
  if valid_564885 != nil:
    section.add "resourceGroupName", valid_564885
  var valid_564886 = path.getOrDefault("factoryName")
  valid_564886 = validateParameter(valid_564886, JString, required = true,
                                 default = nil)
  if valid_564886 != nil:
    section.add "factoryName", valid_564886
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564887 = query.getOrDefault("api-version")
  valid_564887 = validateParameter(valid_564887, JString, required = true,
                                 default = nil)
  if valid_564887 != nil:
    section.add "api-version", valid_564887
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564888: Call_TriggersListByFactory_564881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists triggers.
  ## 
  let valid = call_564888.validator(path, query, header, formData, body)
  let scheme = call_564888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564888.url(scheme.get, call_564888.host, call_564888.base,
                         call_564888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564888, url, valid)

proc call*(call_564889: Call_TriggersListByFactory_564881; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; factoryName: string): Recallable =
  ## triggersListByFactory
  ## Lists triggers.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564890 = newJObject()
  var query_564891 = newJObject()
  add(query_564891, "api-version", newJString(apiVersion))
  add(path_564890, "subscriptionId", newJString(subscriptionId))
  add(path_564890, "resourceGroupName", newJString(resourceGroupName))
  add(path_564890, "factoryName", newJString(factoryName))
  result = call_564889.call(path_564890, query_564891, nil, nil, nil)

var triggersListByFactory* = Call_TriggersListByFactory_564881(
    name: "triggersListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers",
    validator: validate_TriggersListByFactory_564882, base: "",
    url: url_TriggersListByFactory_564883, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_564905 = ref object of OpenApiRestCall_563566
proc url_TriggersCreateOrUpdate_564907(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreateOrUpdate_564906(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564908 = path.getOrDefault("subscriptionId")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "subscriptionId", valid_564908
  var valid_564909 = path.getOrDefault("resourceGroupName")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "resourceGroupName", valid_564909
  var valid_564910 = path.getOrDefault("triggerName")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "triggerName", valid_564910
  var valid_564911 = path.getOrDefault("factoryName")
  valid_564911 = validateParameter(valid_564911, JString, required = true,
                                 default = nil)
  if valid_564911 != nil:
    section.add "factoryName", valid_564911
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564912 = query.getOrDefault("api-version")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "api-version", valid_564912
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the trigger entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564913 = header.getOrDefault("If-Match")
  valid_564913 = validateParameter(valid_564913, JString, required = false,
                                 default = nil)
  if valid_564913 != nil:
    section.add "If-Match", valid_564913
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

proc call*(call_564915: Call_TriggersCreateOrUpdate_564905; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_564915.validator(path, query, header, formData, body)
  let scheme = call_564915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564915.url(scheme.get, call_564915.host, call_564915.base,
                         call_564915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564915, url, valid)

proc call*(call_564916: Call_TriggersCreateOrUpdate_564905; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; triggerName: string;
          factoryName: string; trigger: JsonNode): Recallable =
  ## triggersCreateOrUpdate
  ## Creates or updates a trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   trigger: JObject (required)
  ##          : Trigger resource definition.
  var path_564917 = newJObject()
  var query_564918 = newJObject()
  var body_564919 = newJObject()
  add(query_564918, "api-version", newJString(apiVersion))
  add(path_564917, "subscriptionId", newJString(subscriptionId))
  add(path_564917, "resourceGroupName", newJString(resourceGroupName))
  add(path_564917, "triggerName", newJString(triggerName))
  add(path_564917, "factoryName", newJString(factoryName))
  if trigger != nil:
    body_564919 = trigger
  result = call_564916.call(path_564917, query_564918, nil, nil, body_564919)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_564905(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersCreateOrUpdate_564906, base: "",
    url: url_TriggersCreateOrUpdate_564907, schemes: {Scheme.Https})
type
  Call_TriggersGet_564892 = ref object of OpenApiRestCall_563566
proc url_TriggersGet_564894(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_564893(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564895 = path.getOrDefault("subscriptionId")
  valid_564895 = validateParameter(valid_564895, JString, required = true,
                                 default = nil)
  if valid_564895 != nil:
    section.add "subscriptionId", valid_564895
  var valid_564896 = path.getOrDefault("resourceGroupName")
  valid_564896 = validateParameter(valid_564896, JString, required = true,
                                 default = nil)
  if valid_564896 != nil:
    section.add "resourceGroupName", valid_564896
  var valid_564897 = path.getOrDefault("triggerName")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "triggerName", valid_564897
  var valid_564898 = path.getOrDefault("factoryName")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = nil)
  if valid_564898 != nil:
    section.add "factoryName", valid_564898
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564899 = query.getOrDefault("api-version")
  valid_564899 = validateParameter(valid_564899, JString, required = true,
                                 default = nil)
  if valid_564899 != nil:
    section.add "api-version", valid_564899
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the trigger entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_564900 = header.getOrDefault("If-None-Match")
  valid_564900 = validateParameter(valid_564900, JString, required = false,
                                 default = nil)
  if valid_564900 != nil:
    section.add "If-None-Match", valid_564900
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564901: Call_TriggersGet_564892; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a trigger.
  ## 
  let valid = call_564901.validator(path, query, header, formData, body)
  let scheme = call_564901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564901.url(scheme.get, call_564901.host, call_564901.base,
                         call_564901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564901, url, valid)

proc call*(call_564902: Call_TriggersGet_564892; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; triggerName: string;
          factoryName: string): Recallable =
  ## triggersGet
  ## Gets a trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564903 = newJObject()
  var query_564904 = newJObject()
  add(query_564904, "api-version", newJString(apiVersion))
  add(path_564903, "subscriptionId", newJString(subscriptionId))
  add(path_564903, "resourceGroupName", newJString(resourceGroupName))
  add(path_564903, "triggerName", newJString(triggerName))
  add(path_564903, "factoryName", newJString(factoryName))
  result = call_564902.call(path_564903, query_564904, nil, nil, nil)

var triggersGet* = Call_TriggersGet_564892(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
                                        validator: validate_TriggersGet_564893,
                                        base: "", url: url_TriggersGet_564894,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_564920 = ref object of OpenApiRestCall_563566
proc url_TriggersDelete_564922(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_564921(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564923 = path.getOrDefault("subscriptionId")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "subscriptionId", valid_564923
  var valid_564924 = path.getOrDefault("resourceGroupName")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "resourceGroupName", valid_564924
  var valid_564925 = path.getOrDefault("triggerName")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "triggerName", valid_564925
  var valid_564926 = path.getOrDefault("factoryName")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = nil)
  if valid_564926 != nil:
    section.add "factoryName", valid_564926
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564927 = query.getOrDefault("api-version")
  valid_564927 = validateParameter(valid_564927, JString, required = true,
                                 default = nil)
  if valid_564927 != nil:
    section.add "api-version", valid_564927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564928: Call_TriggersDelete_564920; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a trigger.
  ## 
  let valid = call_564928.validator(path, query, header, formData, body)
  let scheme = call_564928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564928.url(scheme.get, call_564928.host, call_564928.base,
                         call_564928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564928, url, valid)

proc call*(call_564929: Call_TriggersDelete_564920; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; triggerName: string;
          factoryName: string): Recallable =
  ## triggersDelete
  ## Deletes a trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564930 = newJObject()
  var query_564931 = newJObject()
  add(query_564931, "api-version", newJString(apiVersion))
  add(path_564930, "subscriptionId", newJString(subscriptionId))
  add(path_564930, "resourceGroupName", newJString(resourceGroupName))
  add(path_564930, "triggerName", newJString(triggerName))
  add(path_564930, "factoryName", newJString(factoryName))
  result = call_564929.call(path_564930, query_564931, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_564920(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersDelete_564921, base: "", url: url_TriggersDelete_564922,
    schemes: {Scheme.Https})
type
  Call_TriggersGetEventSubscriptionStatus_564932 = ref object of OpenApiRestCall_563566
proc url_TriggersGetEventSubscriptionStatus_564934(protocol: Scheme; host: string;
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

proc validate_TriggersGetEventSubscriptionStatus_564933(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a trigger's event subscription status.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564935 = path.getOrDefault("subscriptionId")
  valid_564935 = validateParameter(valid_564935, JString, required = true,
                                 default = nil)
  if valid_564935 != nil:
    section.add "subscriptionId", valid_564935
  var valid_564936 = path.getOrDefault("resourceGroupName")
  valid_564936 = validateParameter(valid_564936, JString, required = true,
                                 default = nil)
  if valid_564936 != nil:
    section.add "resourceGroupName", valid_564936
  var valid_564937 = path.getOrDefault("triggerName")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "triggerName", valid_564937
  var valid_564938 = path.getOrDefault("factoryName")
  valid_564938 = validateParameter(valid_564938, JString, required = true,
                                 default = nil)
  if valid_564938 != nil:
    section.add "factoryName", valid_564938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564939 = query.getOrDefault("api-version")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "api-version", valid_564939
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564940: Call_TriggersGetEventSubscriptionStatus_564932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a trigger's event subscription status.
  ## 
  let valid = call_564940.validator(path, query, header, formData, body)
  let scheme = call_564940.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564940.url(scheme.get, call_564940.host, call_564940.base,
                         call_564940.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564940, url, valid)

proc call*(call_564941: Call_TriggersGetEventSubscriptionStatus_564932;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          triggerName: string; factoryName: string): Recallable =
  ## triggersGetEventSubscriptionStatus
  ## Get a trigger's event subscription status.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564942 = newJObject()
  var query_564943 = newJObject()
  add(query_564943, "api-version", newJString(apiVersion))
  add(path_564942, "subscriptionId", newJString(subscriptionId))
  add(path_564942, "resourceGroupName", newJString(resourceGroupName))
  add(path_564942, "triggerName", newJString(triggerName))
  add(path_564942, "factoryName", newJString(factoryName))
  result = call_564941.call(path_564942, query_564943, nil, nil, nil)

var triggersGetEventSubscriptionStatus* = Call_TriggersGetEventSubscriptionStatus_564932(
    name: "triggersGetEventSubscriptionStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/getEventSubscriptionStatus",
    validator: validate_TriggersGetEventSubscriptionStatus_564933, base: "",
    url: url_TriggersGetEventSubscriptionStatus_564934, schemes: {Scheme.Https})
type
  Call_RerunTriggersListByTrigger_564944 = ref object of OpenApiRestCall_563566
proc url_RerunTriggersListByTrigger_564946(protocol: Scheme; host: string;
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

proc validate_RerunTriggersListByTrigger_564945(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists rerun triggers by an original trigger name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564947 = path.getOrDefault("subscriptionId")
  valid_564947 = validateParameter(valid_564947, JString, required = true,
                                 default = nil)
  if valid_564947 != nil:
    section.add "subscriptionId", valid_564947
  var valid_564948 = path.getOrDefault("resourceGroupName")
  valid_564948 = validateParameter(valid_564948, JString, required = true,
                                 default = nil)
  if valid_564948 != nil:
    section.add "resourceGroupName", valid_564948
  var valid_564949 = path.getOrDefault("triggerName")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "triggerName", valid_564949
  var valid_564950 = path.getOrDefault("factoryName")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "factoryName", valid_564950
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564951 = query.getOrDefault("api-version")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "api-version", valid_564951
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564952: Call_RerunTriggersListByTrigger_564944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists rerun triggers by an original trigger name.
  ## 
  let valid = call_564952.validator(path, query, header, formData, body)
  let scheme = call_564952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564952.url(scheme.get, call_564952.host, call_564952.base,
                         call_564952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564952, url, valid)

proc call*(call_564953: Call_RerunTriggersListByTrigger_564944; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; triggerName: string;
          factoryName: string): Recallable =
  ## rerunTriggersListByTrigger
  ## Lists rerun triggers by an original trigger name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564954 = newJObject()
  var query_564955 = newJObject()
  add(query_564955, "api-version", newJString(apiVersion))
  add(path_564954, "subscriptionId", newJString(subscriptionId))
  add(path_564954, "resourceGroupName", newJString(resourceGroupName))
  add(path_564954, "triggerName", newJString(triggerName))
  add(path_564954, "factoryName", newJString(factoryName))
  result = call_564953.call(path_564954, query_564955, nil, nil, nil)

var rerunTriggersListByTrigger* = Call_RerunTriggersListByTrigger_564944(
    name: "rerunTriggersListByTrigger", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers",
    validator: validate_RerunTriggersListByTrigger_564945, base: "",
    url: url_RerunTriggersListByTrigger_564946, schemes: {Scheme.Https})
type
  Call_RerunTriggersCreate_564956 = ref object of OpenApiRestCall_563566
proc url_RerunTriggersCreate_564958(protocol: Scheme; host: string; base: string;
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

proc validate_RerunTriggersCreate_564957(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a rerun trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: JString (required)
  ##                   : The rerun trigger name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564959 = path.getOrDefault("subscriptionId")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "subscriptionId", valid_564959
  var valid_564960 = path.getOrDefault("rerunTriggerName")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "rerunTriggerName", valid_564960
  var valid_564961 = path.getOrDefault("resourceGroupName")
  valid_564961 = validateParameter(valid_564961, JString, required = true,
                                 default = nil)
  if valid_564961 != nil:
    section.add "resourceGroupName", valid_564961
  var valid_564962 = path.getOrDefault("triggerName")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = nil)
  if valid_564962 != nil:
    section.add "triggerName", valid_564962
  var valid_564963 = path.getOrDefault("factoryName")
  valid_564963 = validateParameter(valid_564963, JString, required = true,
                                 default = nil)
  if valid_564963 != nil:
    section.add "factoryName", valid_564963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564964 = query.getOrDefault("api-version")
  valid_564964 = validateParameter(valid_564964, JString, required = true,
                                 default = nil)
  if valid_564964 != nil:
    section.add "api-version", valid_564964
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

proc call*(call_564966: Call_RerunTriggersCreate_564956; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a rerun trigger.
  ## 
  let valid = call_564966.validator(path, query, header, formData, body)
  let scheme = call_564966.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564966.url(scheme.get, call_564966.host, call_564966.base,
                         call_564966.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564966, url, valid)

proc call*(call_564967: Call_RerunTriggersCreate_564956; apiVersion: string;
          rerunTumblingWindowTriggerActionParameters: JsonNode;
          subscriptionId: string; rerunTriggerName: string;
          resourceGroupName: string; triggerName: string; factoryName: string): Recallable =
  ## rerunTriggersCreate
  ## Creates a rerun trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   rerunTumblingWindowTriggerActionParameters: JObject (required)
  ##                                             : Rerun tumbling window trigger action parameters.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: string (required)
  ##                   : The rerun trigger name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564968 = newJObject()
  var query_564969 = newJObject()
  var body_564970 = newJObject()
  add(query_564969, "api-version", newJString(apiVersion))
  if rerunTumblingWindowTriggerActionParameters != nil:
    body_564970 = rerunTumblingWindowTriggerActionParameters
  add(path_564968, "subscriptionId", newJString(subscriptionId))
  add(path_564968, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_564968, "resourceGroupName", newJString(resourceGroupName))
  add(path_564968, "triggerName", newJString(triggerName))
  add(path_564968, "factoryName", newJString(factoryName))
  result = call_564967.call(path_564968, query_564969, nil, nil, body_564970)

var rerunTriggersCreate* = Call_RerunTriggersCreate_564956(
    name: "rerunTriggersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}",
    validator: validate_RerunTriggersCreate_564957, base: "",
    url: url_RerunTriggersCreate_564958, schemes: {Scheme.Https})
type
  Call_RerunTriggersCancel_564971 = ref object of OpenApiRestCall_563566
proc url_RerunTriggersCancel_564973(protocol: Scheme; host: string; base: string;
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

proc validate_RerunTriggersCancel_564972(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Cancels a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: JString (required)
  ##                   : The rerun trigger name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564974 = path.getOrDefault("subscriptionId")
  valid_564974 = validateParameter(valid_564974, JString, required = true,
                                 default = nil)
  if valid_564974 != nil:
    section.add "subscriptionId", valid_564974
  var valid_564975 = path.getOrDefault("rerunTriggerName")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = nil)
  if valid_564975 != nil:
    section.add "rerunTriggerName", valid_564975
  var valid_564976 = path.getOrDefault("resourceGroupName")
  valid_564976 = validateParameter(valid_564976, JString, required = true,
                                 default = nil)
  if valid_564976 != nil:
    section.add "resourceGroupName", valid_564976
  var valid_564977 = path.getOrDefault("triggerName")
  valid_564977 = validateParameter(valid_564977, JString, required = true,
                                 default = nil)
  if valid_564977 != nil:
    section.add "triggerName", valid_564977
  var valid_564978 = path.getOrDefault("factoryName")
  valid_564978 = validateParameter(valid_564978, JString, required = true,
                                 default = nil)
  if valid_564978 != nil:
    section.add "factoryName", valid_564978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564979 = query.getOrDefault("api-version")
  valid_564979 = validateParameter(valid_564979, JString, required = true,
                                 default = nil)
  if valid_564979 != nil:
    section.add "api-version", valid_564979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564980: Call_RerunTriggersCancel_564971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a trigger.
  ## 
  let valid = call_564980.validator(path, query, header, formData, body)
  let scheme = call_564980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564980.url(scheme.get, call_564980.host, call_564980.base,
                         call_564980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564980, url, valid)

proc call*(call_564981: Call_RerunTriggersCancel_564971; apiVersion: string;
          subscriptionId: string; rerunTriggerName: string;
          resourceGroupName: string; triggerName: string; factoryName: string): Recallable =
  ## rerunTriggersCancel
  ## Cancels a trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: string (required)
  ##                   : The rerun trigger name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564982 = newJObject()
  var query_564983 = newJObject()
  add(query_564983, "api-version", newJString(apiVersion))
  add(path_564982, "subscriptionId", newJString(subscriptionId))
  add(path_564982, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_564982, "resourceGroupName", newJString(resourceGroupName))
  add(path_564982, "triggerName", newJString(triggerName))
  add(path_564982, "factoryName", newJString(factoryName))
  result = call_564981.call(path_564982, query_564983, nil, nil, nil)

var rerunTriggersCancel* = Call_RerunTriggersCancel_564971(
    name: "rerunTriggersCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}/cancel",
    validator: validate_RerunTriggersCancel_564972, base: "",
    url: url_RerunTriggersCancel_564973, schemes: {Scheme.Https})
type
  Call_RerunTriggersStart_564984 = ref object of OpenApiRestCall_563566
proc url_RerunTriggersStart_564986(protocol: Scheme; host: string; base: string;
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

proc validate_RerunTriggersStart_564985(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Starts a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: JString (required)
  ##                   : The rerun trigger name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564987 = path.getOrDefault("subscriptionId")
  valid_564987 = validateParameter(valid_564987, JString, required = true,
                                 default = nil)
  if valid_564987 != nil:
    section.add "subscriptionId", valid_564987
  var valid_564988 = path.getOrDefault("rerunTriggerName")
  valid_564988 = validateParameter(valid_564988, JString, required = true,
                                 default = nil)
  if valid_564988 != nil:
    section.add "rerunTriggerName", valid_564988
  var valid_564989 = path.getOrDefault("resourceGroupName")
  valid_564989 = validateParameter(valid_564989, JString, required = true,
                                 default = nil)
  if valid_564989 != nil:
    section.add "resourceGroupName", valid_564989
  var valid_564990 = path.getOrDefault("triggerName")
  valid_564990 = validateParameter(valid_564990, JString, required = true,
                                 default = nil)
  if valid_564990 != nil:
    section.add "triggerName", valid_564990
  var valid_564991 = path.getOrDefault("factoryName")
  valid_564991 = validateParameter(valid_564991, JString, required = true,
                                 default = nil)
  if valid_564991 != nil:
    section.add "factoryName", valid_564991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564992 = query.getOrDefault("api-version")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = nil)
  if valid_564992 != nil:
    section.add "api-version", valid_564992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564993: Call_RerunTriggersStart_564984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a trigger.
  ## 
  let valid = call_564993.validator(path, query, header, formData, body)
  let scheme = call_564993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564993.url(scheme.get, call_564993.host, call_564993.base,
                         call_564993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564993, url, valid)

proc call*(call_564994: Call_RerunTriggersStart_564984; apiVersion: string;
          subscriptionId: string; rerunTriggerName: string;
          resourceGroupName: string; triggerName: string; factoryName: string): Recallable =
  ## rerunTriggersStart
  ## Starts a trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: string (required)
  ##                   : The rerun trigger name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564995 = newJObject()
  var query_564996 = newJObject()
  add(query_564996, "api-version", newJString(apiVersion))
  add(path_564995, "subscriptionId", newJString(subscriptionId))
  add(path_564995, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_564995, "resourceGroupName", newJString(resourceGroupName))
  add(path_564995, "triggerName", newJString(triggerName))
  add(path_564995, "factoryName", newJString(factoryName))
  result = call_564994.call(path_564995, query_564996, nil, nil, nil)

var rerunTriggersStart* = Call_RerunTriggersStart_564984(
    name: "rerunTriggersStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}/start",
    validator: validate_RerunTriggersStart_564985, base: "",
    url: url_RerunTriggersStart_564986, schemes: {Scheme.Https})
type
  Call_RerunTriggersStop_564997 = ref object of OpenApiRestCall_563566
proc url_RerunTriggersStop_564999(protocol: Scheme; host: string; base: string;
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

proc validate_RerunTriggersStop_564998(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stops a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: JString (required)
  ##                   : The rerun trigger name.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565000 = path.getOrDefault("subscriptionId")
  valid_565000 = validateParameter(valid_565000, JString, required = true,
                                 default = nil)
  if valid_565000 != nil:
    section.add "subscriptionId", valid_565000
  var valid_565001 = path.getOrDefault("rerunTriggerName")
  valid_565001 = validateParameter(valid_565001, JString, required = true,
                                 default = nil)
  if valid_565001 != nil:
    section.add "rerunTriggerName", valid_565001
  var valid_565002 = path.getOrDefault("resourceGroupName")
  valid_565002 = validateParameter(valid_565002, JString, required = true,
                                 default = nil)
  if valid_565002 != nil:
    section.add "resourceGroupName", valid_565002
  var valid_565003 = path.getOrDefault("triggerName")
  valid_565003 = validateParameter(valid_565003, JString, required = true,
                                 default = nil)
  if valid_565003 != nil:
    section.add "triggerName", valid_565003
  var valid_565004 = path.getOrDefault("factoryName")
  valid_565004 = validateParameter(valid_565004, JString, required = true,
                                 default = nil)
  if valid_565004 != nil:
    section.add "factoryName", valid_565004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565005 = query.getOrDefault("api-version")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "api-version", valid_565005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565006: Call_RerunTriggersStop_564997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a trigger.
  ## 
  let valid = call_565006.validator(path, query, header, formData, body)
  let scheme = call_565006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565006.url(scheme.get, call_565006.host, call_565006.base,
                         call_565006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565006, url, valid)

proc call*(call_565007: Call_RerunTriggersStop_564997; apiVersion: string;
          subscriptionId: string; rerunTriggerName: string;
          resourceGroupName: string; triggerName: string; factoryName: string): Recallable =
  ## rerunTriggersStop
  ## Stops a trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   rerunTriggerName: string (required)
  ##                   : The rerun trigger name.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_565008 = newJObject()
  var query_565009 = newJObject()
  add(query_565009, "api-version", newJString(apiVersion))
  add(path_565008, "subscriptionId", newJString(subscriptionId))
  add(path_565008, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_565008, "resourceGroupName", newJString(resourceGroupName))
  add(path_565008, "triggerName", newJString(triggerName))
  add(path_565008, "factoryName", newJString(factoryName))
  result = call_565007.call(path_565008, query_565009, nil, nil, nil)

var rerunTriggersStop* = Call_RerunTriggersStop_564997(name: "rerunTriggersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}/stop",
    validator: validate_RerunTriggersStop_564998, base: "",
    url: url_RerunTriggersStop_564999, schemes: {Scheme.Https})
type
  Call_TriggersStart_565010 = ref object of OpenApiRestCall_563566
proc url_TriggersStart_565012(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersStart_565011(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565013 = path.getOrDefault("subscriptionId")
  valid_565013 = validateParameter(valid_565013, JString, required = true,
                                 default = nil)
  if valid_565013 != nil:
    section.add "subscriptionId", valid_565013
  var valid_565014 = path.getOrDefault("resourceGroupName")
  valid_565014 = validateParameter(valid_565014, JString, required = true,
                                 default = nil)
  if valid_565014 != nil:
    section.add "resourceGroupName", valid_565014
  var valid_565015 = path.getOrDefault("triggerName")
  valid_565015 = validateParameter(valid_565015, JString, required = true,
                                 default = nil)
  if valid_565015 != nil:
    section.add "triggerName", valid_565015
  var valid_565016 = path.getOrDefault("factoryName")
  valid_565016 = validateParameter(valid_565016, JString, required = true,
                                 default = nil)
  if valid_565016 != nil:
    section.add "factoryName", valid_565016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565017 = query.getOrDefault("api-version")
  valid_565017 = validateParameter(valid_565017, JString, required = true,
                                 default = nil)
  if valid_565017 != nil:
    section.add "api-version", valid_565017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565018: Call_TriggersStart_565010; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a trigger.
  ## 
  let valid = call_565018.validator(path, query, header, formData, body)
  let scheme = call_565018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565018.url(scheme.get, call_565018.host, call_565018.base,
                         call_565018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565018, url, valid)

proc call*(call_565019: Call_TriggersStart_565010; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; triggerName: string;
          factoryName: string): Recallable =
  ## triggersStart
  ## Starts a trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_565020 = newJObject()
  var query_565021 = newJObject()
  add(query_565021, "api-version", newJString(apiVersion))
  add(path_565020, "subscriptionId", newJString(subscriptionId))
  add(path_565020, "resourceGroupName", newJString(resourceGroupName))
  add(path_565020, "triggerName", newJString(triggerName))
  add(path_565020, "factoryName", newJString(factoryName))
  result = call_565019.call(path_565020, query_565021, nil, nil, nil)

var triggersStart* = Call_TriggersStart_565010(name: "triggersStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/start",
    validator: validate_TriggersStart_565011, base: "", url: url_TriggersStart_565012,
    schemes: {Scheme.Https})
type
  Call_TriggersStop_565022 = ref object of OpenApiRestCall_563566
proc url_TriggersStop_565024(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersStop_565023(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a trigger.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565025 = path.getOrDefault("subscriptionId")
  valid_565025 = validateParameter(valid_565025, JString, required = true,
                                 default = nil)
  if valid_565025 != nil:
    section.add "subscriptionId", valid_565025
  var valid_565026 = path.getOrDefault("resourceGroupName")
  valid_565026 = validateParameter(valid_565026, JString, required = true,
                                 default = nil)
  if valid_565026 != nil:
    section.add "resourceGroupName", valid_565026
  var valid_565027 = path.getOrDefault("triggerName")
  valid_565027 = validateParameter(valid_565027, JString, required = true,
                                 default = nil)
  if valid_565027 != nil:
    section.add "triggerName", valid_565027
  var valid_565028 = path.getOrDefault("factoryName")
  valid_565028 = validateParameter(valid_565028, JString, required = true,
                                 default = nil)
  if valid_565028 != nil:
    section.add "factoryName", valid_565028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565029 = query.getOrDefault("api-version")
  valid_565029 = validateParameter(valid_565029, JString, required = true,
                                 default = nil)
  if valid_565029 != nil:
    section.add "api-version", valid_565029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565030: Call_TriggersStop_565022; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a trigger.
  ## 
  let valid = call_565030.validator(path, query, header, formData, body)
  let scheme = call_565030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565030.url(scheme.get, call_565030.host, call_565030.base,
                         call_565030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565030, url, valid)

proc call*(call_565031: Call_TriggersStop_565022; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; triggerName: string;
          factoryName: string): Recallable =
  ## triggersStop
  ## Stops a trigger.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_565032 = newJObject()
  var query_565033 = newJObject()
  add(query_565033, "api-version", newJString(apiVersion))
  add(path_565032, "subscriptionId", newJString(subscriptionId))
  add(path_565032, "resourceGroupName", newJString(resourceGroupName))
  add(path_565032, "triggerName", newJString(triggerName))
  add(path_565032, "factoryName", newJString(factoryName))
  result = call_565031.call(path_565032, query_565033, nil, nil, nil)

var triggersStop* = Call_TriggersStop_565022(name: "triggersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/stop",
    validator: validate_TriggersStop_565023, base: "", url: url_TriggersStop_565024,
    schemes: {Scheme.Https})
type
  Call_TriggersSubscribeToEvents_565034 = ref object of OpenApiRestCall_563566
proc url_TriggersSubscribeToEvents_565036(protocol: Scheme; host: string;
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

proc validate_TriggersSubscribeToEvents_565035(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Subscribe event trigger to events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565037 = path.getOrDefault("subscriptionId")
  valid_565037 = validateParameter(valid_565037, JString, required = true,
                                 default = nil)
  if valid_565037 != nil:
    section.add "subscriptionId", valid_565037
  var valid_565038 = path.getOrDefault("resourceGroupName")
  valid_565038 = validateParameter(valid_565038, JString, required = true,
                                 default = nil)
  if valid_565038 != nil:
    section.add "resourceGroupName", valid_565038
  var valid_565039 = path.getOrDefault("triggerName")
  valid_565039 = validateParameter(valid_565039, JString, required = true,
                                 default = nil)
  if valid_565039 != nil:
    section.add "triggerName", valid_565039
  var valid_565040 = path.getOrDefault("factoryName")
  valid_565040 = validateParameter(valid_565040, JString, required = true,
                                 default = nil)
  if valid_565040 != nil:
    section.add "factoryName", valid_565040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565041 = query.getOrDefault("api-version")
  valid_565041 = validateParameter(valid_565041, JString, required = true,
                                 default = nil)
  if valid_565041 != nil:
    section.add "api-version", valid_565041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565042: Call_TriggersSubscribeToEvents_565034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe event trigger to events.
  ## 
  let valid = call_565042.validator(path, query, header, formData, body)
  let scheme = call_565042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565042.url(scheme.get, call_565042.host, call_565042.base,
                         call_565042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565042, url, valid)

proc call*(call_565043: Call_TriggersSubscribeToEvents_565034; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; triggerName: string;
          factoryName: string): Recallable =
  ## triggersSubscribeToEvents
  ## Subscribe event trigger to events.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_565044 = newJObject()
  var query_565045 = newJObject()
  add(query_565045, "api-version", newJString(apiVersion))
  add(path_565044, "subscriptionId", newJString(subscriptionId))
  add(path_565044, "resourceGroupName", newJString(resourceGroupName))
  add(path_565044, "triggerName", newJString(triggerName))
  add(path_565044, "factoryName", newJString(factoryName))
  result = call_565043.call(path_565044, query_565045, nil, nil, nil)

var triggersSubscribeToEvents* = Call_TriggersSubscribeToEvents_565034(
    name: "triggersSubscribeToEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/subscribeToEvents",
    validator: validate_TriggersSubscribeToEvents_565035, base: "",
    url: url_TriggersSubscribeToEvents_565036, schemes: {Scheme.Https})
type
  Call_TriggerRunsRerun_565046 = ref object of OpenApiRestCall_563566
proc url_TriggerRunsRerun_565048(protocol: Scheme; host: string; base: string;
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

proc validate_TriggerRunsRerun_565047(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Rerun single trigger instance by runId.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   runId: JString (required)
  ##        : The pipeline run identifier.
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `runId` field"
  var valid_565049 = path.getOrDefault("runId")
  valid_565049 = validateParameter(valid_565049, JString, required = true,
                                 default = nil)
  if valid_565049 != nil:
    section.add "runId", valid_565049
  var valid_565050 = path.getOrDefault("subscriptionId")
  valid_565050 = validateParameter(valid_565050, JString, required = true,
                                 default = nil)
  if valid_565050 != nil:
    section.add "subscriptionId", valid_565050
  var valid_565051 = path.getOrDefault("resourceGroupName")
  valid_565051 = validateParameter(valid_565051, JString, required = true,
                                 default = nil)
  if valid_565051 != nil:
    section.add "resourceGroupName", valid_565051
  var valid_565052 = path.getOrDefault("triggerName")
  valid_565052 = validateParameter(valid_565052, JString, required = true,
                                 default = nil)
  if valid_565052 != nil:
    section.add "triggerName", valid_565052
  var valid_565053 = path.getOrDefault("factoryName")
  valid_565053 = validateParameter(valid_565053, JString, required = true,
                                 default = nil)
  if valid_565053 != nil:
    section.add "factoryName", valid_565053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565054 = query.getOrDefault("api-version")
  valid_565054 = validateParameter(valid_565054, JString, required = true,
                                 default = nil)
  if valid_565054 != nil:
    section.add "api-version", valid_565054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565055: Call_TriggerRunsRerun_565046; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rerun single trigger instance by runId.
  ## 
  let valid = call_565055.validator(path, query, header, formData, body)
  let scheme = call_565055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565055.url(scheme.get, call_565055.host, call_565055.base,
                         call_565055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565055, url, valid)

proc call*(call_565056: Call_TriggerRunsRerun_565046; runId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          triggerName: string; factoryName: string): Recallable =
  ## triggerRunsRerun
  ## Rerun single trigger instance by runId.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_565057 = newJObject()
  var query_565058 = newJObject()
  add(path_565057, "runId", newJString(runId))
  add(query_565058, "api-version", newJString(apiVersion))
  add(path_565057, "subscriptionId", newJString(subscriptionId))
  add(path_565057, "resourceGroupName", newJString(resourceGroupName))
  add(path_565057, "triggerName", newJString(triggerName))
  add(path_565057, "factoryName", newJString(factoryName))
  result = call_565056.call(path_565057, query_565058, nil, nil, nil)

var triggerRunsRerun* = Call_TriggerRunsRerun_565046(name: "triggerRunsRerun",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/triggerRuns/{runId}/rerun",
    validator: validate_TriggerRunsRerun_565047, base: "",
    url: url_TriggerRunsRerun_565048, schemes: {Scheme.Https})
type
  Call_TriggersUnsubscribeFromEvents_565059 = ref object of OpenApiRestCall_563566
proc url_TriggersUnsubscribeFromEvents_565061(protocol: Scheme; host: string;
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

proc validate_TriggersUnsubscribeFromEvents_565060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unsubscribe event trigger from events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: JString (required)
  ##                    : The resource group name.
  ##   triggerName: JString (required)
  ##              : The trigger name.
  ##   factoryName: JString (required)
  ##              : The factory name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565062 = path.getOrDefault("subscriptionId")
  valid_565062 = validateParameter(valid_565062, JString, required = true,
                                 default = nil)
  if valid_565062 != nil:
    section.add "subscriptionId", valid_565062
  var valid_565063 = path.getOrDefault("resourceGroupName")
  valid_565063 = validateParameter(valid_565063, JString, required = true,
                                 default = nil)
  if valid_565063 != nil:
    section.add "resourceGroupName", valid_565063
  var valid_565064 = path.getOrDefault("triggerName")
  valid_565064 = validateParameter(valid_565064, JString, required = true,
                                 default = nil)
  if valid_565064 != nil:
    section.add "triggerName", valid_565064
  var valid_565065 = path.getOrDefault("factoryName")
  valid_565065 = validateParameter(valid_565065, JString, required = true,
                                 default = nil)
  if valid_565065 != nil:
    section.add "factoryName", valid_565065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565066 = query.getOrDefault("api-version")
  valid_565066 = validateParameter(valid_565066, JString, required = true,
                                 default = nil)
  if valid_565066 != nil:
    section.add "api-version", valid_565066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565067: Call_TriggersUnsubscribeFromEvents_565059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unsubscribe event trigger from events.
  ## 
  let valid = call_565067.validator(path, query, header, formData, body)
  let scheme = call_565067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565067.url(scheme.get, call_565067.host, call_565067.base,
                         call_565067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565067, url, valid)

proc call*(call_565068: Call_TriggersUnsubscribeFromEvents_565059;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          triggerName: string; factoryName: string): Recallable =
  ## triggersUnsubscribeFromEvents
  ## Unsubscribe event trigger from events.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_565069 = newJObject()
  var query_565070 = newJObject()
  add(query_565070, "api-version", newJString(apiVersion))
  add(path_565069, "subscriptionId", newJString(subscriptionId))
  add(path_565069, "resourceGroupName", newJString(resourceGroupName))
  add(path_565069, "triggerName", newJString(triggerName))
  add(path_565069, "factoryName", newJString(factoryName))
  result = call_565068.call(path_565069, query_565070, nil, nil, nil)

var triggersUnsubscribeFromEvents* = Call_TriggersUnsubscribeFromEvents_565059(
    name: "triggersUnsubscribeFromEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/unsubscribeFromEvents",
    validator: validate_TriggersUnsubscribeFromEvents_565060, base: "",
    url: url_TriggersUnsubscribeFromEvents_565061, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
