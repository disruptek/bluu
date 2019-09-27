
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593439 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593439](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593439): Option[Scheme] {.used.} =
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
  macServiceName = "datafactory"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593661 = ref object of OpenApiRestCall_593439
proc url_OperationsList_593663(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593662(path: JsonNode; query: JsonNode;
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
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593845: Call_OperationsList_593661; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the available Azure Data Factory API operations.
  ## 
  let valid = call_593845.validator(path, query, header, formData, body)
  let scheme = call_593845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593845.url(scheme.get, call_593845.host, call_593845.base,
                         call_593845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593845, url, valid)

proc call*(call_593916: Call_OperationsList_593661; apiVersion: string): Recallable =
  ## operationsList
  ## Lists the available Azure Data Factory API operations.
  ##   apiVersion: string (required)
  ##             : The API version.
  var query_593917 = newJObject()
  add(query_593917, "api-version", newJString(apiVersion))
  result = call_593916.call(nil, query_593917, nil, nil, nil)

var operationsList* = Call_OperationsList_593661(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.DataFactory/operations",
    validator: validate_OperationsList_593662, base: "", url: url_OperationsList_593663,
    schemes: {Scheme.Https})
type
  Call_FactoriesList_593957 = ref object of OpenApiRestCall_593439
proc url_FactoriesList_593959(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesList_593958(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_FactoriesList_593957; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories under the specified subscription.
  ## 
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_FactoriesList_593957; apiVersion: string;
          subscriptionId: string): Recallable =
  ## factoriesList
  ## Lists factories under the specified subscription.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_593978 = newJObject()
  var query_593979 = newJObject()
  add(query_593979, "api-version", newJString(apiVersion))
  add(path_593978, "subscriptionId", newJString(subscriptionId))
  result = call_593977.call(path_593978, query_593979, nil, nil, nil)

var factoriesList* = Call_FactoriesList_593957(name: "factoriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesList_593958, base: "", url: url_FactoriesList_593959,
    schemes: {Scheme.Https})
type
  Call_FactoriesConfigureFactoryRepo_593980 = ref object of OpenApiRestCall_593439
proc url_FactoriesConfigureFactoryRepo_593982(protocol: Scheme; host: string;
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

proc validate_FactoriesConfigureFactoryRepo_593981(path: JsonNode; query: JsonNode;
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
  var valid_594000 = path.getOrDefault("locationId")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "locationId", valid_594000
  var valid_594001 = path.getOrDefault("subscriptionId")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "subscriptionId", valid_594001
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "api-version", valid_594002
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

proc call*(call_594004: Call_FactoriesConfigureFactoryRepo_593980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory's repo information.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_FactoriesConfigureFactoryRepo_593980;
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
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  var body_594008 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "locationId", newJString(locationId))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  if factoryRepoUpdate != nil:
    body_594008 = factoryRepoUpdate
  result = call_594005.call(path_594006, query_594007, nil, nil, body_594008)

var factoriesConfigureFactoryRepo* = Call_FactoriesConfigureFactoryRepo_593980(
    name: "factoriesConfigureFactoryRepo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/locations/{locationId}/configureFactoryRepo",
    validator: validate_FactoriesConfigureFactoryRepo_593981, base: "",
    url: url_FactoriesConfigureFactoryRepo_593982, schemes: {Scheme.Https})
type
  Call_ExposureControlGetFeatureValue_594009 = ref object of OpenApiRestCall_593439
proc url_ExposureControlGetFeatureValue_594011(protocol: Scheme; host: string;
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

proc validate_ExposureControlGetFeatureValue_594010(path: JsonNode;
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
  var valid_594012 = path.getOrDefault("locationId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "locationId", valid_594012
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
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

proc call*(call_594016: Call_ExposureControlGetFeatureValue_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get exposure control feature for specific location.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_ExposureControlGetFeatureValue_594009;
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
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  var body_594020 = newJObject()
  add(query_594019, "api-version", newJString(apiVersion))
  add(path_594018, "locationId", newJString(locationId))
  add(path_594018, "subscriptionId", newJString(subscriptionId))
  if exposureControlRequest != nil:
    body_594020 = exposureControlRequest
  result = call_594017.call(path_594018, query_594019, nil, nil, body_594020)

var exposureControlGetFeatureValue* = Call_ExposureControlGetFeatureValue_594009(
    name: "exposureControlGetFeatureValue", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.DataFactory/locations/{locationId}/getFeatureValue",
    validator: validate_ExposureControlGetFeatureValue_594010, base: "",
    url: url_ExposureControlGetFeatureValue_594011, schemes: {Scheme.Https})
type
  Call_FactoriesListByResourceGroup_594021 = ref object of OpenApiRestCall_593439
proc url_FactoriesListByResourceGroup_594023(protocol: Scheme; host: string;
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

proc validate_FactoriesListByResourceGroup_594022(path: JsonNode; query: JsonNode;
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
  var valid_594024 = path.getOrDefault("resourceGroupName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "resourceGroupName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_FactoriesListByResourceGroup_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_FactoriesListByResourceGroup_594021;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## factoriesListByResourceGroup
  ## Lists factories.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(path_594029, "resourceGroupName", newJString(resourceGroupName))
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "subscriptionId", newJString(subscriptionId))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var factoriesListByResourceGroup* = Call_FactoriesListByResourceGroup_594021(
    name: "factoriesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesListByResourceGroup_594022, base: "",
    url: url_FactoriesListByResourceGroup_594023, schemes: {Scheme.Https})
type
  Call_FactoriesCreateOrUpdate_594043 = ref object of OpenApiRestCall_593439
proc url_FactoriesCreateOrUpdate_594045(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesCreateOrUpdate_594044(path: JsonNode; query: JsonNode;
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
  var valid_594046 = path.getOrDefault("resourceGroupName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceGroupName", valid_594046
  var valid_594047 = path.getOrDefault("factoryName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "factoryName", valid_594047
  var valid_594048 = path.getOrDefault("subscriptionId")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "subscriptionId", valid_594048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the factory entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594050 = header.getOrDefault("If-Match")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "If-Match", valid_594050
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

proc call*(call_594052: Call_FactoriesCreateOrUpdate_594043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a factory.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_FactoriesCreateOrUpdate_594043;
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
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  var body_594056 = newJObject()
  add(path_594054, "resourceGroupName", newJString(resourceGroupName))
  add(path_594054, "factoryName", newJString(factoryName))
  add(query_594055, "api-version", newJString(apiVersion))
  add(path_594054, "subscriptionId", newJString(subscriptionId))
  if factory != nil:
    body_594056 = factory
  result = call_594053.call(path_594054, query_594055, nil, nil, body_594056)

var factoriesCreateOrUpdate* = Call_FactoriesCreateOrUpdate_594043(
    name: "factoriesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesCreateOrUpdate_594044, base: "",
    url: url_FactoriesCreateOrUpdate_594045, schemes: {Scheme.Https})
type
  Call_FactoriesGet_594031 = ref object of OpenApiRestCall_593439
proc url_FactoriesGet_594033(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesGet_594032(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594034 = path.getOrDefault("resourceGroupName")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "resourceGroupName", valid_594034
  var valid_594035 = path.getOrDefault("factoryName")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "factoryName", valid_594035
  var valid_594036 = path.getOrDefault("subscriptionId")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "subscriptionId", valid_594036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594037 = query.getOrDefault("api-version")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "api-version", valid_594037
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the factory entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_594038 = header.getOrDefault("If-None-Match")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "If-None-Match", valid_594038
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594039: Call_FactoriesGet_594031; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a factory.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_FactoriesGet_594031; resourceGroupName: string;
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
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  add(path_594041, "resourceGroupName", newJString(resourceGroupName))
  add(path_594041, "factoryName", newJString(factoryName))
  add(query_594042, "api-version", newJString(apiVersion))
  add(path_594041, "subscriptionId", newJString(subscriptionId))
  result = call_594040.call(path_594041, query_594042, nil, nil, nil)

var factoriesGet* = Call_FactoriesGet_594031(name: "factoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesGet_594032, base: "", url: url_FactoriesGet_594033,
    schemes: {Scheme.Https})
type
  Call_FactoriesUpdate_594068 = ref object of OpenApiRestCall_593439
proc url_FactoriesUpdate_594070(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesUpdate_594069(path: JsonNode; query: JsonNode;
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
  var valid_594071 = path.getOrDefault("resourceGroupName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "resourceGroupName", valid_594071
  var valid_594072 = path.getOrDefault("factoryName")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "factoryName", valid_594072
  var valid_594073 = path.getOrDefault("subscriptionId")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "subscriptionId", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594074 = query.getOrDefault("api-version")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "api-version", valid_594074
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

proc call*(call_594076: Call_FactoriesUpdate_594068; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_FactoriesUpdate_594068; resourceGroupName: string;
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
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  var body_594080 = newJObject()
  add(path_594078, "resourceGroupName", newJString(resourceGroupName))
  add(path_594078, "factoryName", newJString(factoryName))
  add(query_594079, "api-version", newJString(apiVersion))
  add(path_594078, "subscriptionId", newJString(subscriptionId))
  if factoryUpdateParameters != nil:
    body_594080 = factoryUpdateParameters
  result = call_594077.call(path_594078, query_594079, nil, nil, body_594080)

var factoriesUpdate* = Call_FactoriesUpdate_594068(name: "factoriesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesUpdate_594069, base: "", url: url_FactoriesUpdate_594070,
    schemes: {Scheme.Https})
type
  Call_FactoriesDelete_594057 = ref object of OpenApiRestCall_593439
proc url_FactoriesDelete_594059(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesDelete_594058(path: JsonNode; query: JsonNode;
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
  var valid_594060 = path.getOrDefault("resourceGroupName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "resourceGroupName", valid_594060
  var valid_594061 = path.getOrDefault("factoryName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "factoryName", valid_594061
  var valid_594062 = path.getOrDefault("subscriptionId")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "subscriptionId", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594064: Call_FactoriesDelete_594057; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a factory.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_FactoriesDelete_594057; resourceGroupName: string;
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
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(path_594066, "resourceGroupName", newJString(resourceGroupName))
  add(path_594066, "factoryName", newJString(factoryName))
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "subscriptionId", newJString(subscriptionId))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var factoriesDelete* = Call_FactoriesDelete_594057(name: "factoriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesDelete_594058, base: "", url: url_FactoriesDelete_594059,
    schemes: {Scheme.Https})
type
  Call_DatasetsListByFactory_594081 = ref object of OpenApiRestCall_593439
proc url_DatasetsListByFactory_594083(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsListByFactory_594082(path: JsonNode; query: JsonNode;
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
  var valid_594084 = path.getOrDefault("resourceGroupName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "resourceGroupName", valid_594084
  var valid_594085 = path.getOrDefault("factoryName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "factoryName", valid_594085
  var valid_594086 = path.getOrDefault("subscriptionId")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "subscriptionId", valid_594086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594087 = query.getOrDefault("api-version")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "api-version", valid_594087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594088: Call_DatasetsListByFactory_594081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists datasets.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_DatasetsListByFactory_594081;
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
  var path_594090 = newJObject()
  var query_594091 = newJObject()
  add(path_594090, "resourceGroupName", newJString(resourceGroupName))
  add(path_594090, "factoryName", newJString(factoryName))
  add(query_594091, "api-version", newJString(apiVersion))
  add(path_594090, "subscriptionId", newJString(subscriptionId))
  result = call_594089.call(path_594090, query_594091, nil, nil, nil)

var datasetsListByFactory* = Call_DatasetsListByFactory_594081(
    name: "datasetsListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets",
    validator: validate_DatasetsListByFactory_594082, base: "",
    url: url_DatasetsListByFactory_594083, schemes: {Scheme.Https})
type
  Call_DatasetsCreateOrUpdate_594105 = ref object of OpenApiRestCall_593439
proc url_DatasetsCreateOrUpdate_594107(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsCreateOrUpdate_594106(path: JsonNode; query: JsonNode;
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
  var valid_594108 = path.getOrDefault("resourceGroupName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "resourceGroupName", valid_594108
  var valid_594109 = path.getOrDefault("factoryName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "factoryName", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
  var valid_594111 = path.getOrDefault("datasetName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "datasetName", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594112 = query.getOrDefault("api-version")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "api-version", valid_594112
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the dataset entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594113 = header.getOrDefault("If-Match")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "If-Match", valid_594113
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

proc call*(call_594115: Call_DatasetsCreateOrUpdate_594105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a dataset.
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_DatasetsCreateOrUpdate_594105;
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
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  var body_594119 = newJObject()
  add(path_594117, "resourceGroupName", newJString(resourceGroupName))
  add(path_594117, "factoryName", newJString(factoryName))
  add(query_594118, "api-version", newJString(apiVersion))
  add(path_594117, "subscriptionId", newJString(subscriptionId))
  add(path_594117, "datasetName", newJString(datasetName))
  if dataset != nil:
    body_594119 = dataset
  result = call_594116.call(path_594117, query_594118, nil, nil, body_594119)

var datasetsCreateOrUpdate* = Call_DatasetsCreateOrUpdate_594105(
    name: "datasetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsCreateOrUpdate_594106, base: "",
    url: url_DatasetsCreateOrUpdate_594107, schemes: {Scheme.Https})
type
  Call_DatasetsGet_594092 = ref object of OpenApiRestCall_593439
proc url_DatasetsGet_594094(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsGet_594093(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594095 = path.getOrDefault("resourceGroupName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "resourceGroupName", valid_594095
  var valid_594096 = path.getOrDefault("factoryName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "factoryName", valid_594096
  var valid_594097 = path.getOrDefault("subscriptionId")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "subscriptionId", valid_594097
  var valid_594098 = path.getOrDefault("datasetName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "datasetName", valid_594098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594099 = query.getOrDefault("api-version")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "api-version", valid_594099
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the dataset entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_594100 = header.getOrDefault("If-None-Match")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "If-None-Match", valid_594100
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_DatasetsGet_594092; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a dataset.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_DatasetsGet_594092; resourceGroupName: string;
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
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(path_594103, "resourceGroupName", newJString(resourceGroupName))
  add(path_594103, "factoryName", newJString(factoryName))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  add(path_594103, "datasetName", newJString(datasetName))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var datasetsGet* = Call_DatasetsGet_594092(name: "datasetsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
                                        validator: validate_DatasetsGet_594093,
                                        base: "", url: url_DatasetsGet_594094,
                                        schemes: {Scheme.Https})
type
  Call_DatasetsDelete_594120 = ref object of OpenApiRestCall_593439
proc url_DatasetsDelete_594122(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsDelete_594121(path: JsonNode; query: JsonNode;
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
  var valid_594123 = path.getOrDefault("resourceGroupName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "resourceGroupName", valid_594123
  var valid_594124 = path.getOrDefault("factoryName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "factoryName", valid_594124
  var valid_594125 = path.getOrDefault("subscriptionId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "subscriptionId", valid_594125
  var valid_594126 = path.getOrDefault("datasetName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "datasetName", valid_594126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594127 = query.getOrDefault("api-version")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "api-version", valid_594127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594128: Call_DatasetsDelete_594120; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a dataset.
  ## 
  let valid = call_594128.validator(path, query, header, formData, body)
  let scheme = call_594128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594128.url(scheme.get, call_594128.host, call_594128.base,
                         call_594128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594128, url, valid)

proc call*(call_594129: Call_DatasetsDelete_594120; resourceGroupName: string;
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
  var path_594130 = newJObject()
  var query_594131 = newJObject()
  add(path_594130, "resourceGroupName", newJString(resourceGroupName))
  add(path_594130, "factoryName", newJString(factoryName))
  add(query_594131, "api-version", newJString(apiVersion))
  add(path_594130, "subscriptionId", newJString(subscriptionId))
  add(path_594130, "datasetName", newJString(datasetName))
  result = call_594129.call(path_594130, query_594131, nil, nil, nil)

var datasetsDelete* = Call_DatasetsDelete_594120(name: "datasetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsDelete_594121, base: "", url: url_DatasetsDelete_594122,
    schemes: {Scheme.Https})
type
  Call_FactoriesGetDataPlaneAccess_594132 = ref object of OpenApiRestCall_593439
proc url_FactoriesGetDataPlaneAccess_594134(protocol: Scheme; host: string;
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

proc validate_FactoriesGetDataPlaneAccess_594133(path: JsonNode; query: JsonNode;
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
  var valid_594135 = path.getOrDefault("resourceGroupName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "resourceGroupName", valid_594135
  var valid_594136 = path.getOrDefault("factoryName")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "factoryName", valid_594136
  var valid_594137 = path.getOrDefault("subscriptionId")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "subscriptionId", valid_594137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594138 = query.getOrDefault("api-version")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "api-version", valid_594138
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

proc call*(call_594140: Call_FactoriesGetDataPlaneAccess_594132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get Data Plane access.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_FactoriesGetDataPlaneAccess_594132;
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
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  var body_594144 = newJObject()
  add(path_594142, "resourceGroupName", newJString(resourceGroupName))
  add(path_594142, "factoryName", newJString(factoryName))
  add(query_594143, "api-version", newJString(apiVersion))
  add(path_594142, "subscriptionId", newJString(subscriptionId))
  if policy != nil:
    body_594144 = policy
  result = call_594141.call(path_594142, query_594143, nil, nil, body_594144)

var factoriesGetDataPlaneAccess* = Call_FactoriesGetDataPlaneAccess_594132(
    name: "factoriesGetDataPlaneAccess", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/getDataPlaneAccess",
    validator: validate_FactoriesGetDataPlaneAccess_594133, base: "",
    url: url_FactoriesGetDataPlaneAccess_594134, schemes: {Scheme.Https})
type
  Call_ExposureControlGetFeatureValueByFactory_594145 = ref object of OpenApiRestCall_593439
proc url_ExposureControlGetFeatureValueByFactory_594147(protocol: Scheme;
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

proc validate_ExposureControlGetFeatureValueByFactory_594146(path: JsonNode;
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
  var valid_594148 = path.getOrDefault("resourceGroupName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "resourceGroupName", valid_594148
  var valid_594149 = path.getOrDefault("factoryName")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "factoryName", valid_594149
  var valid_594150 = path.getOrDefault("subscriptionId")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "subscriptionId", valid_594150
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594151 = query.getOrDefault("api-version")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "api-version", valid_594151
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

proc call*(call_594153: Call_ExposureControlGetFeatureValueByFactory_594145;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get exposure control feature for specific factory.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_ExposureControlGetFeatureValueByFactory_594145;
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
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  var body_594157 = newJObject()
  add(path_594155, "resourceGroupName", newJString(resourceGroupName))
  add(path_594155, "factoryName", newJString(factoryName))
  add(query_594156, "api-version", newJString(apiVersion))
  add(path_594155, "subscriptionId", newJString(subscriptionId))
  if exposureControlRequest != nil:
    body_594157 = exposureControlRequest
  result = call_594154.call(path_594155, query_594156, nil, nil, body_594157)

var exposureControlGetFeatureValueByFactory* = Call_ExposureControlGetFeatureValueByFactory_594145(
    name: "exposureControlGetFeatureValueByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/getFeatureValue",
    validator: validate_ExposureControlGetFeatureValueByFactory_594146, base: "",
    url: url_ExposureControlGetFeatureValueByFactory_594147,
    schemes: {Scheme.Https})
type
  Call_FactoriesGetGitHubAccessToken_594158 = ref object of OpenApiRestCall_593439
proc url_FactoriesGetGitHubAccessToken_594160(protocol: Scheme; host: string;
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

proc validate_FactoriesGetGitHubAccessToken_594159(path: JsonNode; query: JsonNode;
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
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("factoryName")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = nil)
  if valid_594162 != nil:
    section.add "factoryName", valid_594162
  var valid_594163 = path.getOrDefault("subscriptionId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "subscriptionId", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594164 = query.getOrDefault("api-version")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "api-version", valid_594164
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

proc call*(call_594166: Call_FactoriesGetGitHubAccessToken_594158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get GitHub Access Token.
  ## 
  let valid = call_594166.validator(path, query, header, formData, body)
  let scheme = call_594166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594166.url(scheme.get, call_594166.host, call_594166.base,
                         call_594166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594166, url, valid)

proc call*(call_594167: Call_FactoriesGetGitHubAccessToken_594158;
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
  var path_594168 = newJObject()
  var query_594169 = newJObject()
  var body_594170 = newJObject()
  add(path_594168, "resourceGroupName", newJString(resourceGroupName))
  add(path_594168, "factoryName", newJString(factoryName))
  add(query_594169, "api-version", newJString(apiVersion))
  add(path_594168, "subscriptionId", newJString(subscriptionId))
  if gitHubAccessTokenRequest != nil:
    body_594170 = gitHubAccessTokenRequest
  result = call_594167.call(path_594168, query_594169, nil, nil, body_594170)

var factoriesGetGitHubAccessToken* = Call_FactoriesGetGitHubAccessToken_594158(
    name: "factoriesGetGitHubAccessToken", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/getGitHubAccessToken",
    validator: validate_FactoriesGetGitHubAccessToken_594159, base: "",
    url: url_FactoriesGetGitHubAccessToken_594160, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListByFactory_594171 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesListByFactory_594173(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesListByFactory_594172(path: JsonNode;
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
  var valid_594174 = path.getOrDefault("resourceGroupName")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "resourceGroupName", valid_594174
  var valid_594175 = path.getOrDefault("factoryName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "factoryName", valid_594175
  var valid_594176 = path.getOrDefault("subscriptionId")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "subscriptionId", valid_594176
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594177 = query.getOrDefault("api-version")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "api-version", valid_594177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594178: Call_IntegrationRuntimesListByFactory_594171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists integration runtimes.
  ## 
  let valid = call_594178.validator(path, query, header, formData, body)
  let scheme = call_594178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594178.url(scheme.get, call_594178.host, call_594178.base,
                         call_594178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594178, url, valid)

proc call*(call_594179: Call_IntegrationRuntimesListByFactory_594171;
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
  var path_594180 = newJObject()
  var query_594181 = newJObject()
  add(path_594180, "resourceGroupName", newJString(resourceGroupName))
  add(path_594180, "factoryName", newJString(factoryName))
  add(query_594181, "api-version", newJString(apiVersion))
  add(path_594180, "subscriptionId", newJString(subscriptionId))
  result = call_594179.call(path_594180, query_594181, nil, nil, nil)

var integrationRuntimesListByFactory* = Call_IntegrationRuntimesListByFactory_594171(
    name: "integrationRuntimesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes",
    validator: validate_IntegrationRuntimesListByFactory_594172, base: "",
    url: url_IntegrationRuntimesListByFactory_594173, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesCreateOrUpdate_594195 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesCreateOrUpdate_594197(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesCreateOrUpdate_594196(path: JsonNode;
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
  var valid_594198 = path.getOrDefault("resourceGroupName")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "resourceGroupName", valid_594198
  var valid_594199 = path.getOrDefault("factoryName")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "factoryName", valid_594199
  var valid_594200 = path.getOrDefault("integrationRuntimeName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "integrationRuntimeName", valid_594200
  var valid_594201 = path.getOrDefault("subscriptionId")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "subscriptionId", valid_594201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594202 = query.getOrDefault("api-version")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "api-version", valid_594202
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the integration runtime entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594203 = header.getOrDefault("If-Match")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "If-Match", valid_594203
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

proc call*(call_594205: Call_IntegrationRuntimesCreateOrUpdate_594195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration runtime.
  ## 
  let valid = call_594205.validator(path, query, header, formData, body)
  let scheme = call_594205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594205.url(scheme.get, call_594205.host, call_594205.base,
                         call_594205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594205, url, valid)

proc call*(call_594206: Call_IntegrationRuntimesCreateOrUpdate_594195;
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
  var path_594207 = newJObject()
  var query_594208 = newJObject()
  var body_594209 = newJObject()
  add(path_594207, "resourceGroupName", newJString(resourceGroupName))
  add(path_594207, "factoryName", newJString(factoryName))
  add(query_594208, "api-version", newJString(apiVersion))
  add(path_594207, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594207, "subscriptionId", newJString(subscriptionId))
  if integrationRuntime != nil:
    body_594209 = integrationRuntime
  result = call_594206.call(path_594207, query_594208, nil, nil, body_594209)

var integrationRuntimesCreateOrUpdate* = Call_IntegrationRuntimesCreateOrUpdate_594195(
    name: "integrationRuntimesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesCreateOrUpdate_594196, base: "",
    url: url_IntegrationRuntimesCreateOrUpdate_594197, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGet_594182 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesGet_594184(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationRuntimesGet_594183(path: JsonNode; query: JsonNode;
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
  var valid_594185 = path.getOrDefault("resourceGroupName")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "resourceGroupName", valid_594185
  var valid_594186 = path.getOrDefault("factoryName")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "factoryName", valid_594186
  var valid_594187 = path.getOrDefault("integrationRuntimeName")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "integrationRuntimeName", valid_594187
  var valid_594188 = path.getOrDefault("subscriptionId")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "subscriptionId", valid_594188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594189 = query.getOrDefault("api-version")
  valid_594189 = validateParameter(valid_594189, JString, required = true,
                                 default = nil)
  if valid_594189 != nil:
    section.add "api-version", valid_594189
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the integration runtime entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_594190 = header.getOrDefault("If-None-Match")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "If-None-Match", valid_594190
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594191: Call_IntegrationRuntimesGet_594182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration runtime.
  ## 
  let valid = call_594191.validator(path, query, header, formData, body)
  let scheme = call_594191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594191.url(scheme.get, call_594191.host, call_594191.base,
                         call_594191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594191, url, valid)

proc call*(call_594192: Call_IntegrationRuntimesGet_594182;
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
  var path_594193 = newJObject()
  var query_594194 = newJObject()
  add(path_594193, "resourceGroupName", newJString(resourceGroupName))
  add(path_594193, "factoryName", newJString(factoryName))
  add(query_594194, "api-version", newJString(apiVersion))
  add(path_594193, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594193, "subscriptionId", newJString(subscriptionId))
  result = call_594192.call(path_594193, query_594194, nil, nil, nil)

var integrationRuntimesGet* = Call_IntegrationRuntimesGet_594182(
    name: "integrationRuntimesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesGet_594183, base: "",
    url: url_IntegrationRuntimesGet_594184, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpdate_594222 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesUpdate_594224(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesUpdate_594223(path: JsonNode; query: JsonNode;
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
  var valid_594225 = path.getOrDefault("resourceGroupName")
  valid_594225 = validateParameter(valid_594225, JString, required = true,
                                 default = nil)
  if valid_594225 != nil:
    section.add "resourceGroupName", valid_594225
  var valid_594226 = path.getOrDefault("factoryName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "factoryName", valid_594226
  var valid_594227 = path.getOrDefault("integrationRuntimeName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "integrationRuntimeName", valid_594227
  var valid_594228 = path.getOrDefault("subscriptionId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "subscriptionId", valid_594228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594229 = query.getOrDefault("api-version")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "api-version", valid_594229
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

proc call*(call_594231: Call_IntegrationRuntimesUpdate_594222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration runtime.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_IntegrationRuntimesUpdate_594222;
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
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  var body_594235 = newJObject()
  add(path_594233, "resourceGroupName", newJString(resourceGroupName))
  add(path_594233, "factoryName", newJString(factoryName))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594233, "subscriptionId", newJString(subscriptionId))
  if updateIntegrationRuntimeRequest != nil:
    body_594235 = updateIntegrationRuntimeRequest
  result = call_594232.call(path_594233, query_594234, nil, nil, body_594235)

var integrationRuntimesUpdate* = Call_IntegrationRuntimesUpdate_594222(
    name: "integrationRuntimesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesUpdate_594223, base: "",
    url: url_IntegrationRuntimesUpdate_594224, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesDelete_594210 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesDelete_594212(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesDelete_594211(path: JsonNode; query: JsonNode;
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
  var valid_594213 = path.getOrDefault("resourceGroupName")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = nil)
  if valid_594213 != nil:
    section.add "resourceGroupName", valid_594213
  var valid_594214 = path.getOrDefault("factoryName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "factoryName", valid_594214
  var valid_594215 = path.getOrDefault("integrationRuntimeName")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "integrationRuntimeName", valid_594215
  var valid_594216 = path.getOrDefault("subscriptionId")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "subscriptionId", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594218: Call_IntegrationRuntimesDelete_594210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration runtime.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_IntegrationRuntimesDelete_594210;
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
  var path_594220 = newJObject()
  var query_594221 = newJObject()
  add(path_594220, "resourceGroupName", newJString(resourceGroupName))
  add(path_594220, "factoryName", newJString(factoryName))
  add(query_594221, "api-version", newJString(apiVersion))
  add(path_594220, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594220, "subscriptionId", newJString(subscriptionId))
  result = call_594219.call(path_594220, query_594221, nil, nil, nil)

var integrationRuntimesDelete* = Call_IntegrationRuntimesDelete_594210(
    name: "integrationRuntimesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesDelete_594211, base: "",
    url: url_IntegrationRuntimesDelete_594212, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetConnectionInfo_594236 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesGetConnectionInfo_594238(protocol: Scheme;
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

proc validate_IntegrationRuntimesGetConnectionInfo_594237(path: JsonNode;
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
  var valid_594239 = path.getOrDefault("resourceGroupName")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "resourceGroupName", valid_594239
  var valid_594240 = path.getOrDefault("factoryName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "factoryName", valid_594240
  var valid_594241 = path.getOrDefault("integrationRuntimeName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "integrationRuntimeName", valid_594241
  var valid_594242 = path.getOrDefault("subscriptionId")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "subscriptionId", valid_594242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594243 = query.getOrDefault("api-version")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "api-version", valid_594243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594244: Call_IntegrationRuntimesGetConnectionInfo_594236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ## 
  let valid = call_594244.validator(path, query, header, formData, body)
  let scheme = call_594244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594244.url(scheme.get, call_594244.host, call_594244.base,
                         call_594244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594244, url, valid)

proc call*(call_594245: Call_IntegrationRuntimesGetConnectionInfo_594236;
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
  var path_594246 = newJObject()
  var query_594247 = newJObject()
  add(path_594246, "resourceGroupName", newJString(resourceGroupName))
  add(path_594246, "factoryName", newJString(factoryName))
  add(query_594247, "api-version", newJString(apiVersion))
  add(path_594246, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594246, "subscriptionId", newJString(subscriptionId))
  result = call_594245.call(path_594246, query_594247, nil, nil, nil)

var integrationRuntimesGetConnectionInfo* = Call_IntegrationRuntimesGetConnectionInfo_594236(
    name: "integrationRuntimesGetConnectionInfo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getConnectionInfo",
    validator: validate_IntegrationRuntimesGetConnectionInfo_594237, base: "",
    url: url_IntegrationRuntimesGetConnectionInfo_594238, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeObjectMetadataGet_594248 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimeObjectMetadataGet_594250(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeObjectMetadataGet_594249(path: JsonNode;
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
  var valid_594251 = path.getOrDefault("resourceGroupName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "resourceGroupName", valid_594251
  var valid_594252 = path.getOrDefault("factoryName")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "factoryName", valid_594252
  var valid_594253 = path.getOrDefault("integrationRuntimeName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "integrationRuntimeName", valid_594253
  var valid_594254 = path.getOrDefault("subscriptionId")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "subscriptionId", valid_594254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594255 = query.getOrDefault("api-version")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "api-version", valid_594255
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

proc call*(call_594257: Call_IntegrationRuntimeObjectMetadataGet_594248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a SSIS integration runtime object metadata by specified path. The return is pageable metadata list.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_IntegrationRuntimeObjectMetadataGet_594248;
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
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  var body_594261 = newJObject()
  add(path_594259, "resourceGroupName", newJString(resourceGroupName))
  add(path_594259, "factoryName", newJString(factoryName))
  add(query_594260, "api-version", newJString(apiVersion))
  add(path_594259, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594259, "subscriptionId", newJString(subscriptionId))
  if getMetadataRequest != nil:
    body_594261 = getMetadataRequest
  result = call_594258.call(path_594259, query_594260, nil, nil, body_594261)

var integrationRuntimeObjectMetadataGet* = Call_IntegrationRuntimeObjectMetadataGet_594248(
    name: "integrationRuntimeObjectMetadataGet", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getObjectMetadata",
    validator: validate_IntegrationRuntimeObjectMetadataGet_594249, base: "",
    url: url_IntegrationRuntimeObjectMetadataGet_594250, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetStatus_594262 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesGetStatus_594264(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesGetStatus_594263(path: JsonNode; query: JsonNode;
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
  var valid_594265 = path.getOrDefault("resourceGroupName")
  valid_594265 = validateParameter(valid_594265, JString, required = true,
                                 default = nil)
  if valid_594265 != nil:
    section.add "resourceGroupName", valid_594265
  var valid_594266 = path.getOrDefault("factoryName")
  valid_594266 = validateParameter(valid_594266, JString, required = true,
                                 default = nil)
  if valid_594266 != nil:
    section.add "factoryName", valid_594266
  var valid_594267 = path.getOrDefault("integrationRuntimeName")
  valid_594267 = validateParameter(valid_594267, JString, required = true,
                                 default = nil)
  if valid_594267 != nil:
    section.add "integrationRuntimeName", valid_594267
  var valid_594268 = path.getOrDefault("subscriptionId")
  valid_594268 = validateParameter(valid_594268, JString, required = true,
                                 default = nil)
  if valid_594268 != nil:
    section.add "subscriptionId", valid_594268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594269 = query.getOrDefault("api-version")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "api-version", valid_594269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594270: Call_IntegrationRuntimesGetStatus_594262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets detailed status information for an integration runtime.
  ## 
  let valid = call_594270.validator(path, query, header, formData, body)
  let scheme = call_594270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594270.url(scheme.get, call_594270.host, call_594270.base,
                         call_594270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594270, url, valid)

proc call*(call_594271: Call_IntegrationRuntimesGetStatus_594262;
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
  var path_594272 = newJObject()
  var query_594273 = newJObject()
  add(path_594272, "resourceGroupName", newJString(resourceGroupName))
  add(path_594272, "factoryName", newJString(factoryName))
  add(query_594273, "api-version", newJString(apiVersion))
  add(path_594272, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594272, "subscriptionId", newJString(subscriptionId))
  result = call_594271.call(path_594272, query_594273, nil, nil, nil)

var integrationRuntimesGetStatus* = Call_IntegrationRuntimesGetStatus_594262(
    name: "integrationRuntimesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getStatus",
    validator: validate_IntegrationRuntimesGetStatus_594263, base: "",
    url: url_IntegrationRuntimesGetStatus_594264, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_594274 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesCreateLinkedIntegrationRuntime_594276(
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

proc validate_IntegrationRuntimesCreateLinkedIntegrationRuntime_594275(
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
  var valid_594277 = path.getOrDefault("resourceGroupName")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "resourceGroupName", valid_594277
  var valid_594278 = path.getOrDefault("factoryName")
  valid_594278 = validateParameter(valid_594278, JString, required = true,
                                 default = nil)
  if valid_594278 != nil:
    section.add "factoryName", valid_594278
  var valid_594279 = path.getOrDefault("integrationRuntimeName")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = nil)
  if valid_594279 != nil:
    section.add "integrationRuntimeName", valid_594279
  var valid_594280 = path.getOrDefault("subscriptionId")
  valid_594280 = validateParameter(valid_594280, JString, required = true,
                                 default = nil)
  if valid_594280 != nil:
    section.add "subscriptionId", valid_594280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594281 = query.getOrDefault("api-version")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "api-version", valid_594281
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

proc call*(call_594283: Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_594274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a linked integration runtime entry in a shared integration runtime.
  ## 
  let valid = call_594283.validator(path, query, header, formData, body)
  let scheme = call_594283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594283.url(scheme.get, call_594283.host, call_594283.base,
                         call_594283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594283, url, valid)

proc call*(call_594284: Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_594274;
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
  var path_594285 = newJObject()
  var query_594286 = newJObject()
  var body_594287 = newJObject()
  add(path_594285, "resourceGroupName", newJString(resourceGroupName))
  add(path_594285, "factoryName", newJString(factoryName))
  add(query_594286, "api-version", newJString(apiVersion))
  add(path_594285, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594285, "subscriptionId", newJString(subscriptionId))
  if createLinkedIntegrationRuntimeRequest != nil:
    body_594287 = createLinkedIntegrationRuntimeRequest
  result = call_594284.call(path_594285, query_594286, nil, nil, body_594287)

var integrationRuntimesCreateLinkedIntegrationRuntime* = Call_IntegrationRuntimesCreateLinkedIntegrationRuntime_594274(
    name: "integrationRuntimesCreateLinkedIntegrationRuntime",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/linkedIntegrationRuntime",
    validator: validate_IntegrationRuntimesCreateLinkedIntegrationRuntime_594275,
    base: "", url: url_IntegrationRuntimesCreateLinkedIntegrationRuntime_594276,
    schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListAuthKeys_594288 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesListAuthKeys_594290(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesListAuthKeys_594289(path: JsonNode;
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
  var valid_594291 = path.getOrDefault("resourceGroupName")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = nil)
  if valid_594291 != nil:
    section.add "resourceGroupName", valid_594291
  var valid_594292 = path.getOrDefault("factoryName")
  valid_594292 = validateParameter(valid_594292, JString, required = true,
                                 default = nil)
  if valid_594292 != nil:
    section.add "factoryName", valid_594292
  var valid_594293 = path.getOrDefault("integrationRuntimeName")
  valid_594293 = validateParameter(valid_594293, JString, required = true,
                                 default = nil)
  if valid_594293 != nil:
    section.add "integrationRuntimeName", valid_594293
  var valid_594294 = path.getOrDefault("subscriptionId")
  valid_594294 = validateParameter(valid_594294, JString, required = true,
                                 default = nil)
  if valid_594294 != nil:
    section.add "subscriptionId", valid_594294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594295 = query.getOrDefault("api-version")
  valid_594295 = validateParameter(valid_594295, JString, required = true,
                                 default = nil)
  if valid_594295 != nil:
    section.add "api-version", valid_594295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594296: Call_IntegrationRuntimesListAuthKeys_594288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authentication keys for an integration runtime.
  ## 
  let valid = call_594296.validator(path, query, header, formData, body)
  let scheme = call_594296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594296.url(scheme.get, call_594296.host, call_594296.base,
                         call_594296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594296, url, valid)

proc call*(call_594297: Call_IntegrationRuntimesListAuthKeys_594288;
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
  var path_594298 = newJObject()
  var query_594299 = newJObject()
  add(path_594298, "resourceGroupName", newJString(resourceGroupName))
  add(path_594298, "factoryName", newJString(factoryName))
  add(query_594299, "api-version", newJString(apiVersion))
  add(path_594298, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594298, "subscriptionId", newJString(subscriptionId))
  result = call_594297.call(path_594298, query_594299, nil, nil, nil)

var integrationRuntimesListAuthKeys* = Call_IntegrationRuntimesListAuthKeys_594288(
    name: "integrationRuntimesListAuthKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/listAuthKeys",
    validator: validate_IntegrationRuntimesListAuthKeys_594289, base: "",
    url: url_IntegrationRuntimesListAuthKeys_594290, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetMonitoringData_594300 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesGetMonitoringData_594302(protocol: Scheme;
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

proc validate_IntegrationRuntimesGetMonitoringData_594301(path: JsonNode;
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
  var valid_594303 = path.getOrDefault("resourceGroupName")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "resourceGroupName", valid_594303
  var valid_594304 = path.getOrDefault("factoryName")
  valid_594304 = validateParameter(valid_594304, JString, required = true,
                                 default = nil)
  if valid_594304 != nil:
    section.add "factoryName", valid_594304
  var valid_594305 = path.getOrDefault("integrationRuntimeName")
  valid_594305 = validateParameter(valid_594305, JString, required = true,
                                 default = nil)
  if valid_594305 != nil:
    section.add "integrationRuntimeName", valid_594305
  var valid_594306 = path.getOrDefault("subscriptionId")
  valid_594306 = validateParameter(valid_594306, JString, required = true,
                                 default = nil)
  if valid_594306 != nil:
    section.add "subscriptionId", valid_594306
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594307 = query.getOrDefault("api-version")
  valid_594307 = validateParameter(valid_594307, JString, required = true,
                                 default = nil)
  if valid_594307 != nil:
    section.add "api-version", valid_594307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594308: Call_IntegrationRuntimesGetMonitoringData_594300;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ## 
  let valid = call_594308.validator(path, query, header, formData, body)
  let scheme = call_594308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594308.url(scheme.get, call_594308.host, call_594308.base,
                         call_594308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594308, url, valid)

proc call*(call_594309: Call_IntegrationRuntimesGetMonitoringData_594300;
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
  var path_594310 = newJObject()
  var query_594311 = newJObject()
  add(path_594310, "resourceGroupName", newJString(resourceGroupName))
  add(path_594310, "factoryName", newJString(factoryName))
  add(query_594311, "api-version", newJString(apiVersion))
  add(path_594310, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594310, "subscriptionId", newJString(subscriptionId))
  result = call_594309.call(path_594310, query_594311, nil, nil, nil)

var integrationRuntimesGetMonitoringData* = Call_IntegrationRuntimesGetMonitoringData_594300(
    name: "integrationRuntimesGetMonitoringData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/monitoringData",
    validator: validate_IntegrationRuntimesGetMonitoringData_594301, base: "",
    url: url_IntegrationRuntimesGetMonitoringData_594302, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesGet_594312 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimeNodesGet_594314(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesGet_594313(path: JsonNode; query: JsonNode;
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
  var valid_594315 = path.getOrDefault("resourceGroupName")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "resourceGroupName", valid_594315
  var valid_594316 = path.getOrDefault("factoryName")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "factoryName", valid_594316
  var valid_594317 = path.getOrDefault("nodeName")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "nodeName", valid_594317
  var valid_594318 = path.getOrDefault("integrationRuntimeName")
  valid_594318 = validateParameter(valid_594318, JString, required = true,
                                 default = nil)
  if valid_594318 != nil:
    section.add "integrationRuntimeName", valid_594318
  var valid_594319 = path.getOrDefault("subscriptionId")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "subscriptionId", valid_594319
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594320 = query.getOrDefault("api-version")
  valid_594320 = validateParameter(valid_594320, JString, required = true,
                                 default = nil)
  if valid_594320 != nil:
    section.add "api-version", valid_594320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594321: Call_IntegrationRuntimeNodesGet_594312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a self-hosted integration runtime node.
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_IntegrationRuntimeNodesGet_594312;
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
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  add(path_594323, "resourceGroupName", newJString(resourceGroupName))
  add(path_594323, "factoryName", newJString(factoryName))
  add(query_594324, "api-version", newJString(apiVersion))
  add(path_594323, "nodeName", newJString(nodeName))
  add(path_594323, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594323, "subscriptionId", newJString(subscriptionId))
  result = call_594322.call(path_594323, query_594324, nil, nil, nil)

var integrationRuntimeNodesGet* = Call_IntegrationRuntimeNodesGet_594312(
    name: "integrationRuntimeNodesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesGet_594313, base: "",
    url: url_IntegrationRuntimeNodesGet_594314, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesUpdate_594338 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimeNodesUpdate_594340(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesUpdate_594339(path: JsonNode; query: JsonNode;
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
  var valid_594341 = path.getOrDefault("resourceGroupName")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "resourceGroupName", valid_594341
  var valid_594342 = path.getOrDefault("factoryName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "factoryName", valid_594342
  var valid_594343 = path.getOrDefault("nodeName")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "nodeName", valid_594343
  var valid_594344 = path.getOrDefault("integrationRuntimeName")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "integrationRuntimeName", valid_594344
  var valid_594345 = path.getOrDefault("subscriptionId")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "subscriptionId", valid_594345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594346 = query.getOrDefault("api-version")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "api-version", valid_594346
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

proc call*(call_594348: Call_IntegrationRuntimeNodesUpdate_594338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a self-hosted integration runtime node.
  ## 
  let valid = call_594348.validator(path, query, header, formData, body)
  let scheme = call_594348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594348.url(scheme.get, call_594348.host, call_594348.base,
                         call_594348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594348, url, valid)

proc call*(call_594349: Call_IntegrationRuntimeNodesUpdate_594338;
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
  var path_594350 = newJObject()
  var query_594351 = newJObject()
  var body_594352 = newJObject()
  add(path_594350, "resourceGroupName", newJString(resourceGroupName))
  add(path_594350, "factoryName", newJString(factoryName))
  add(query_594351, "api-version", newJString(apiVersion))
  add(path_594350, "nodeName", newJString(nodeName))
  add(path_594350, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594350, "subscriptionId", newJString(subscriptionId))
  if updateIntegrationRuntimeNodeRequest != nil:
    body_594352 = updateIntegrationRuntimeNodeRequest
  result = call_594349.call(path_594350, query_594351, nil, nil, body_594352)

var integrationRuntimeNodesUpdate* = Call_IntegrationRuntimeNodesUpdate_594338(
    name: "integrationRuntimeNodesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesUpdate_594339, base: "",
    url: url_IntegrationRuntimeNodesUpdate_594340, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesDelete_594325 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimeNodesDelete_594327(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesDelete_594326(path: JsonNode; query: JsonNode;
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
  var valid_594328 = path.getOrDefault("resourceGroupName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "resourceGroupName", valid_594328
  var valid_594329 = path.getOrDefault("factoryName")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "factoryName", valid_594329
  var valid_594330 = path.getOrDefault("nodeName")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "nodeName", valid_594330
  var valid_594331 = path.getOrDefault("integrationRuntimeName")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "integrationRuntimeName", valid_594331
  var valid_594332 = path.getOrDefault("subscriptionId")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "subscriptionId", valid_594332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594333 = query.getOrDefault("api-version")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "api-version", valid_594333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594334: Call_IntegrationRuntimeNodesDelete_594325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a self-hosted integration runtime node.
  ## 
  let valid = call_594334.validator(path, query, header, formData, body)
  let scheme = call_594334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594334.url(scheme.get, call_594334.host, call_594334.base,
                         call_594334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594334, url, valid)

proc call*(call_594335: Call_IntegrationRuntimeNodesDelete_594325;
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
  var path_594336 = newJObject()
  var query_594337 = newJObject()
  add(path_594336, "resourceGroupName", newJString(resourceGroupName))
  add(path_594336, "factoryName", newJString(factoryName))
  add(query_594337, "api-version", newJString(apiVersion))
  add(path_594336, "nodeName", newJString(nodeName))
  add(path_594336, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594336, "subscriptionId", newJString(subscriptionId))
  result = call_594335.call(path_594336, query_594337, nil, nil, nil)

var integrationRuntimeNodesDelete* = Call_IntegrationRuntimeNodesDelete_594325(
    name: "integrationRuntimeNodesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesDelete_594326, base: "",
    url: url_IntegrationRuntimeNodesDelete_594327, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesGetIpAddress_594353 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimeNodesGetIpAddress_594355(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesGetIpAddress_594354(path: JsonNode;
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
  var valid_594356 = path.getOrDefault("resourceGroupName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "resourceGroupName", valid_594356
  var valid_594357 = path.getOrDefault("factoryName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "factoryName", valid_594357
  var valid_594358 = path.getOrDefault("nodeName")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "nodeName", valid_594358
  var valid_594359 = path.getOrDefault("integrationRuntimeName")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "integrationRuntimeName", valid_594359
  var valid_594360 = path.getOrDefault("subscriptionId")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = nil)
  if valid_594360 != nil:
    section.add "subscriptionId", valid_594360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594361 = query.getOrDefault("api-version")
  valid_594361 = validateParameter(valid_594361, JString, required = true,
                                 default = nil)
  if valid_594361 != nil:
    section.add "api-version", valid_594361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594362: Call_IntegrationRuntimeNodesGetIpAddress_594353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IP address of self-hosted integration runtime node.
  ## 
  let valid = call_594362.validator(path, query, header, formData, body)
  let scheme = call_594362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594362.url(scheme.get, call_594362.host, call_594362.base,
                         call_594362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594362, url, valid)

proc call*(call_594363: Call_IntegrationRuntimeNodesGetIpAddress_594353;
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
  var path_594364 = newJObject()
  var query_594365 = newJObject()
  add(path_594364, "resourceGroupName", newJString(resourceGroupName))
  add(path_594364, "factoryName", newJString(factoryName))
  add(query_594365, "api-version", newJString(apiVersion))
  add(path_594364, "nodeName", newJString(nodeName))
  add(path_594364, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594364, "subscriptionId", newJString(subscriptionId))
  result = call_594363.call(path_594364, query_594365, nil, nil, nil)

var integrationRuntimeNodesGetIpAddress* = Call_IntegrationRuntimeNodesGetIpAddress_594353(
    name: "integrationRuntimeNodesGetIpAddress", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}/ipAddress",
    validator: validate_IntegrationRuntimeNodesGetIpAddress_594354, base: "",
    url: url_IntegrationRuntimeNodesGetIpAddress_594355, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeObjectMetadataRefresh_594366 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimeObjectMetadataRefresh_594368(protocol: Scheme;
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

proc validate_IntegrationRuntimeObjectMetadataRefresh_594367(path: JsonNode;
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
  var valid_594369 = path.getOrDefault("resourceGroupName")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "resourceGroupName", valid_594369
  var valid_594370 = path.getOrDefault("factoryName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "factoryName", valid_594370
  var valid_594371 = path.getOrDefault("integrationRuntimeName")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "integrationRuntimeName", valid_594371
  var valid_594372 = path.getOrDefault("subscriptionId")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "subscriptionId", valid_594372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594373 = query.getOrDefault("api-version")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "api-version", valid_594373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594374: Call_IntegrationRuntimeObjectMetadataRefresh_594366;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Refresh a SSIS integration runtime object metadata.
  ## 
  let valid = call_594374.validator(path, query, header, formData, body)
  let scheme = call_594374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594374.url(scheme.get, call_594374.host, call_594374.base,
                         call_594374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594374, url, valid)

proc call*(call_594375: Call_IntegrationRuntimeObjectMetadataRefresh_594366;
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
  var path_594376 = newJObject()
  var query_594377 = newJObject()
  add(path_594376, "resourceGroupName", newJString(resourceGroupName))
  add(path_594376, "factoryName", newJString(factoryName))
  add(query_594377, "api-version", newJString(apiVersion))
  add(path_594376, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594376, "subscriptionId", newJString(subscriptionId))
  result = call_594375.call(path_594376, query_594377, nil, nil, nil)

var integrationRuntimeObjectMetadataRefresh* = Call_IntegrationRuntimeObjectMetadataRefresh_594366(
    name: "integrationRuntimeObjectMetadataRefresh", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/refreshObjectMetadata",
    validator: validate_IntegrationRuntimeObjectMetadataRefresh_594367, base: "",
    url: url_IntegrationRuntimeObjectMetadataRefresh_594368,
    schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRegenerateAuthKey_594378 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesRegenerateAuthKey_594380(protocol: Scheme;
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

proc validate_IntegrationRuntimesRegenerateAuthKey_594379(path: JsonNode;
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
  var valid_594381 = path.getOrDefault("resourceGroupName")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "resourceGroupName", valid_594381
  var valid_594382 = path.getOrDefault("factoryName")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "factoryName", valid_594382
  var valid_594383 = path.getOrDefault("integrationRuntimeName")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "integrationRuntimeName", valid_594383
  var valid_594384 = path.getOrDefault("subscriptionId")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "subscriptionId", valid_594384
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594385 = query.getOrDefault("api-version")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "api-version", valid_594385
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

proc call*(call_594387: Call_IntegrationRuntimesRegenerateAuthKey_594378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the authentication key for an integration runtime.
  ## 
  let valid = call_594387.validator(path, query, header, formData, body)
  let scheme = call_594387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594387.url(scheme.get, call_594387.host, call_594387.base,
                         call_594387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594387, url, valid)

proc call*(call_594388: Call_IntegrationRuntimesRegenerateAuthKey_594378;
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
  var path_594389 = newJObject()
  var query_594390 = newJObject()
  var body_594391 = newJObject()
  add(path_594389, "resourceGroupName", newJString(resourceGroupName))
  add(path_594389, "factoryName", newJString(factoryName))
  add(query_594390, "api-version", newJString(apiVersion))
  if regenerateKeyParameters != nil:
    body_594391 = regenerateKeyParameters
  add(path_594389, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594389, "subscriptionId", newJString(subscriptionId))
  result = call_594388.call(path_594389, query_594390, nil, nil, body_594391)

var integrationRuntimesRegenerateAuthKey* = Call_IntegrationRuntimesRegenerateAuthKey_594378(
    name: "integrationRuntimesRegenerateAuthKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/regenerateAuthKey",
    validator: validate_IntegrationRuntimesRegenerateAuthKey_594379, base: "",
    url: url_IntegrationRuntimesRegenerateAuthKey_594380, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRemoveLinks_594392 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesRemoveLinks_594394(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesRemoveLinks_594393(path: JsonNode;
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
  var valid_594395 = path.getOrDefault("resourceGroupName")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "resourceGroupName", valid_594395
  var valid_594396 = path.getOrDefault("factoryName")
  valid_594396 = validateParameter(valid_594396, JString, required = true,
                                 default = nil)
  if valid_594396 != nil:
    section.add "factoryName", valid_594396
  var valid_594397 = path.getOrDefault("integrationRuntimeName")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "integrationRuntimeName", valid_594397
  var valid_594398 = path.getOrDefault("subscriptionId")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "subscriptionId", valid_594398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594399 = query.getOrDefault("api-version")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "api-version", valid_594399
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

proc call*(call_594401: Call_IntegrationRuntimesRemoveLinks_594392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove all linked integration runtimes under specific data factory in a self-hosted integration runtime.
  ## 
  let valid = call_594401.validator(path, query, header, formData, body)
  let scheme = call_594401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594401.url(scheme.get, call_594401.host, call_594401.base,
                         call_594401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594401, url, valid)

proc call*(call_594402: Call_IntegrationRuntimesRemoveLinks_594392;
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
  var path_594403 = newJObject()
  var query_594404 = newJObject()
  var body_594405 = newJObject()
  add(path_594403, "resourceGroupName", newJString(resourceGroupName))
  add(path_594403, "factoryName", newJString(factoryName))
  add(query_594404, "api-version", newJString(apiVersion))
  if linkedIntegrationRuntimeRequest != nil:
    body_594405 = linkedIntegrationRuntimeRequest
  add(path_594403, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594403, "subscriptionId", newJString(subscriptionId))
  result = call_594402.call(path_594403, query_594404, nil, nil, body_594405)

var integrationRuntimesRemoveLinks* = Call_IntegrationRuntimesRemoveLinks_594392(
    name: "integrationRuntimesRemoveLinks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/removeLinks",
    validator: validate_IntegrationRuntimesRemoveLinks_594393, base: "",
    url: url_IntegrationRuntimesRemoveLinks_594394, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStart_594406 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesStart_594408(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesStart_594407(path: JsonNode; query: JsonNode;
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
  var valid_594409 = path.getOrDefault("resourceGroupName")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "resourceGroupName", valid_594409
  var valid_594410 = path.getOrDefault("factoryName")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "factoryName", valid_594410
  var valid_594411 = path.getOrDefault("integrationRuntimeName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "integrationRuntimeName", valid_594411
  var valid_594412 = path.getOrDefault("subscriptionId")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "subscriptionId", valid_594412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594413 = query.getOrDefault("api-version")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "api-version", valid_594413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594414: Call_IntegrationRuntimesStart_594406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a ManagedReserved type integration runtime.
  ## 
  let valid = call_594414.validator(path, query, header, formData, body)
  let scheme = call_594414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594414.url(scheme.get, call_594414.host, call_594414.base,
                         call_594414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594414, url, valid)

proc call*(call_594415: Call_IntegrationRuntimesStart_594406;
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
  var path_594416 = newJObject()
  var query_594417 = newJObject()
  add(path_594416, "resourceGroupName", newJString(resourceGroupName))
  add(path_594416, "factoryName", newJString(factoryName))
  add(query_594417, "api-version", newJString(apiVersion))
  add(path_594416, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594416, "subscriptionId", newJString(subscriptionId))
  result = call_594415.call(path_594416, query_594417, nil, nil, nil)

var integrationRuntimesStart* = Call_IntegrationRuntimesStart_594406(
    name: "integrationRuntimesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/start",
    validator: validate_IntegrationRuntimesStart_594407, base: "",
    url: url_IntegrationRuntimesStart_594408, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStop_594418 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesStop_594420(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationRuntimesStop_594419(path: JsonNode; query: JsonNode;
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
  var valid_594421 = path.getOrDefault("resourceGroupName")
  valid_594421 = validateParameter(valid_594421, JString, required = true,
                                 default = nil)
  if valid_594421 != nil:
    section.add "resourceGroupName", valid_594421
  var valid_594422 = path.getOrDefault("factoryName")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "factoryName", valid_594422
  var valid_594423 = path.getOrDefault("integrationRuntimeName")
  valid_594423 = validateParameter(valid_594423, JString, required = true,
                                 default = nil)
  if valid_594423 != nil:
    section.add "integrationRuntimeName", valid_594423
  var valid_594424 = path.getOrDefault("subscriptionId")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "subscriptionId", valid_594424
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594425 = query.getOrDefault("api-version")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "api-version", valid_594425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594426: Call_IntegrationRuntimesStop_594418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a ManagedReserved type integration runtime.
  ## 
  let valid = call_594426.validator(path, query, header, formData, body)
  let scheme = call_594426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594426.url(scheme.get, call_594426.host, call_594426.base,
                         call_594426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594426, url, valid)

proc call*(call_594427: Call_IntegrationRuntimesStop_594418;
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
  var path_594428 = newJObject()
  var query_594429 = newJObject()
  add(path_594428, "resourceGroupName", newJString(resourceGroupName))
  add(path_594428, "factoryName", newJString(factoryName))
  add(query_594429, "api-version", newJString(apiVersion))
  add(path_594428, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594428, "subscriptionId", newJString(subscriptionId))
  result = call_594427.call(path_594428, query_594429, nil, nil, nil)

var integrationRuntimesStop* = Call_IntegrationRuntimesStop_594418(
    name: "integrationRuntimesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/stop",
    validator: validate_IntegrationRuntimesStop_594419, base: "",
    url: url_IntegrationRuntimesStop_594420, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesSyncCredentials_594430 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesSyncCredentials_594432(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesSyncCredentials_594431(path: JsonNode;
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
  var valid_594433 = path.getOrDefault("resourceGroupName")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "resourceGroupName", valid_594433
  var valid_594434 = path.getOrDefault("factoryName")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "factoryName", valid_594434
  var valid_594435 = path.getOrDefault("integrationRuntimeName")
  valid_594435 = validateParameter(valid_594435, JString, required = true,
                                 default = nil)
  if valid_594435 != nil:
    section.add "integrationRuntimeName", valid_594435
  var valid_594436 = path.getOrDefault("subscriptionId")
  valid_594436 = validateParameter(valid_594436, JString, required = true,
                                 default = nil)
  if valid_594436 != nil:
    section.add "subscriptionId", valid_594436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594437 = query.getOrDefault("api-version")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "api-version", valid_594437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594438: Call_IntegrationRuntimesSyncCredentials_594430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ## 
  let valid = call_594438.validator(path, query, header, formData, body)
  let scheme = call_594438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594438.url(scheme.get, call_594438.host, call_594438.base,
                         call_594438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594438, url, valid)

proc call*(call_594439: Call_IntegrationRuntimesSyncCredentials_594430;
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
  var path_594440 = newJObject()
  var query_594441 = newJObject()
  add(path_594440, "resourceGroupName", newJString(resourceGroupName))
  add(path_594440, "factoryName", newJString(factoryName))
  add(query_594441, "api-version", newJString(apiVersion))
  add(path_594440, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594440, "subscriptionId", newJString(subscriptionId))
  result = call_594439.call(path_594440, query_594441, nil, nil, nil)

var integrationRuntimesSyncCredentials* = Call_IntegrationRuntimesSyncCredentials_594430(
    name: "integrationRuntimesSyncCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/syncCredentials",
    validator: validate_IntegrationRuntimesSyncCredentials_594431, base: "",
    url: url_IntegrationRuntimesSyncCredentials_594432, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpgrade_594442 = ref object of OpenApiRestCall_593439
proc url_IntegrationRuntimesUpgrade_594444(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesUpgrade_594443(path: JsonNode; query: JsonNode;
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
  var valid_594445 = path.getOrDefault("resourceGroupName")
  valid_594445 = validateParameter(valid_594445, JString, required = true,
                                 default = nil)
  if valid_594445 != nil:
    section.add "resourceGroupName", valid_594445
  var valid_594446 = path.getOrDefault("factoryName")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "factoryName", valid_594446
  var valid_594447 = path.getOrDefault("integrationRuntimeName")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "integrationRuntimeName", valid_594447
  var valid_594448 = path.getOrDefault("subscriptionId")
  valid_594448 = validateParameter(valid_594448, JString, required = true,
                                 default = nil)
  if valid_594448 != nil:
    section.add "subscriptionId", valid_594448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594449 = query.getOrDefault("api-version")
  valid_594449 = validateParameter(valid_594449, JString, required = true,
                                 default = nil)
  if valid_594449 != nil:
    section.add "api-version", valid_594449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594450: Call_IntegrationRuntimesUpgrade_594442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ## 
  let valid = call_594450.validator(path, query, header, formData, body)
  let scheme = call_594450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594450.url(scheme.get, call_594450.host, call_594450.base,
                         call_594450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594450, url, valid)

proc call*(call_594451: Call_IntegrationRuntimesUpgrade_594442;
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
  var path_594452 = newJObject()
  var query_594453 = newJObject()
  add(path_594452, "resourceGroupName", newJString(resourceGroupName))
  add(path_594452, "factoryName", newJString(factoryName))
  add(query_594453, "api-version", newJString(apiVersion))
  add(path_594452, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_594452, "subscriptionId", newJString(subscriptionId))
  result = call_594451.call(path_594452, query_594453, nil, nil, nil)

var integrationRuntimesUpgrade* = Call_IntegrationRuntimesUpgrade_594442(
    name: "integrationRuntimesUpgrade", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/upgrade",
    validator: validate_IntegrationRuntimesUpgrade_594443, base: "",
    url: url_IntegrationRuntimesUpgrade_594444, schemes: {Scheme.Https})
type
  Call_LinkedServicesListByFactory_594454 = ref object of OpenApiRestCall_593439
proc url_LinkedServicesListByFactory_594456(protocol: Scheme; host: string;
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

proc validate_LinkedServicesListByFactory_594455(path: JsonNode; query: JsonNode;
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
  var valid_594457 = path.getOrDefault("resourceGroupName")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "resourceGroupName", valid_594457
  var valid_594458 = path.getOrDefault("factoryName")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "factoryName", valid_594458
  var valid_594459 = path.getOrDefault("subscriptionId")
  valid_594459 = validateParameter(valid_594459, JString, required = true,
                                 default = nil)
  if valid_594459 != nil:
    section.add "subscriptionId", valid_594459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594460 = query.getOrDefault("api-version")
  valid_594460 = validateParameter(valid_594460, JString, required = true,
                                 default = nil)
  if valid_594460 != nil:
    section.add "api-version", valid_594460
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594461: Call_LinkedServicesListByFactory_594454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists linked services.
  ## 
  let valid = call_594461.validator(path, query, header, formData, body)
  let scheme = call_594461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594461.url(scheme.get, call_594461.host, call_594461.base,
                         call_594461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594461, url, valid)

proc call*(call_594462: Call_LinkedServicesListByFactory_594454;
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
  var path_594463 = newJObject()
  var query_594464 = newJObject()
  add(path_594463, "resourceGroupName", newJString(resourceGroupName))
  add(path_594463, "factoryName", newJString(factoryName))
  add(query_594464, "api-version", newJString(apiVersion))
  add(path_594463, "subscriptionId", newJString(subscriptionId))
  result = call_594462.call(path_594463, query_594464, nil, nil, nil)

var linkedServicesListByFactory* = Call_LinkedServicesListByFactory_594454(
    name: "linkedServicesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices",
    validator: validate_LinkedServicesListByFactory_594455, base: "",
    url: url_LinkedServicesListByFactory_594456, schemes: {Scheme.Https})
type
  Call_LinkedServicesCreateOrUpdate_594478 = ref object of OpenApiRestCall_593439
proc url_LinkedServicesCreateOrUpdate_594480(protocol: Scheme; host: string;
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

proc validate_LinkedServicesCreateOrUpdate_594479(path: JsonNode; query: JsonNode;
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
  var valid_594481 = path.getOrDefault("resourceGroupName")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "resourceGroupName", valid_594481
  var valid_594482 = path.getOrDefault("factoryName")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "factoryName", valid_594482
  var valid_594483 = path.getOrDefault("linkedServiceName")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "linkedServiceName", valid_594483
  var valid_594484 = path.getOrDefault("subscriptionId")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "subscriptionId", valid_594484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594485 = query.getOrDefault("api-version")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "api-version", valid_594485
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the linkedService entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594486 = header.getOrDefault("If-Match")
  valid_594486 = validateParameter(valid_594486, JString, required = false,
                                 default = nil)
  if valid_594486 != nil:
    section.add "If-Match", valid_594486
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

proc call*(call_594488: Call_LinkedServicesCreateOrUpdate_594478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a linked service.
  ## 
  let valid = call_594488.validator(path, query, header, formData, body)
  let scheme = call_594488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594488.url(scheme.get, call_594488.host, call_594488.base,
                         call_594488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594488, url, valid)

proc call*(call_594489: Call_LinkedServicesCreateOrUpdate_594478;
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
  var path_594490 = newJObject()
  var query_594491 = newJObject()
  var body_594492 = newJObject()
  add(path_594490, "resourceGroupName", newJString(resourceGroupName))
  add(path_594490, "factoryName", newJString(factoryName))
  add(query_594491, "api-version", newJString(apiVersion))
  add(path_594490, "linkedServiceName", newJString(linkedServiceName))
  add(path_594490, "subscriptionId", newJString(subscriptionId))
  if linkedService != nil:
    body_594492 = linkedService
  result = call_594489.call(path_594490, query_594491, nil, nil, body_594492)

var linkedServicesCreateOrUpdate* = Call_LinkedServicesCreateOrUpdate_594478(
    name: "linkedServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesCreateOrUpdate_594479, base: "",
    url: url_LinkedServicesCreateOrUpdate_594480, schemes: {Scheme.Https})
type
  Call_LinkedServicesGet_594465 = ref object of OpenApiRestCall_593439
proc url_LinkedServicesGet_594467(protocol: Scheme; host: string; base: string;
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

proc validate_LinkedServicesGet_594466(path: JsonNode; query: JsonNode;
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
  var valid_594468 = path.getOrDefault("resourceGroupName")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "resourceGroupName", valid_594468
  var valid_594469 = path.getOrDefault("factoryName")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "factoryName", valid_594469
  var valid_594470 = path.getOrDefault("linkedServiceName")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "linkedServiceName", valid_594470
  var valid_594471 = path.getOrDefault("subscriptionId")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "subscriptionId", valid_594471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594472 = query.getOrDefault("api-version")
  valid_594472 = validateParameter(valid_594472, JString, required = true,
                                 default = nil)
  if valid_594472 != nil:
    section.add "api-version", valid_594472
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the linked service entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_594473 = header.getOrDefault("If-None-Match")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = nil)
  if valid_594473 != nil:
    section.add "If-None-Match", valid_594473
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594474: Call_LinkedServicesGet_594465; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a linked service.
  ## 
  let valid = call_594474.validator(path, query, header, formData, body)
  let scheme = call_594474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594474.url(scheme.get, call_594474.host, call_594474.base,
                         call_594474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594474, url, valid)

proc call*(call_594475: Call_LinkedServicesGet_594465; resourceGroupName: string;
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
  var path_594476 = newJObject()
  var query_594477 = newJObject()
  add(path_594476, "resourceGroupName", newJString(resourceGroupName))
  add(path_594476, "factoryName", newJString(factoryName))
  add(query_594477, "api-version", newJString(apiVersion))
  add(path_594476, "linkedServiceName", newJString(linkedServiceName))
  add(path_594476, "subscriptionId", newJString(subscriptionId))
  result = call_594475.call(path_594476, query_594477, nil, nil, nil)

var linkedServicesGet* = Call_LinkedServicesGet_594465(name: "linkedServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesGet_594466, base: "",
    url: url_LinkedServicesGet_594467, schemes: {Scheme.Https})
type
  Call_LinkedServicesDelete_594493 = ref object of OpenApiRestCall_593439
proc url_LinkedServicesDelete_594495(protocol: Scheme; host: string; base: string;
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

proc validate_LinkedServicesDelete_594494(path: JsonNode; query: JsonNode;
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
  var valid_594496 = path.getOrDefault("resourceGroupName")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "resourceGroupName", valid_594496
  var valid_594497 = path.getOrDefault("factoryName")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "factoryName", valid_594497
  var valid_594498 = path.getOrDefault("linkedServiceName")
  valid_594498 = validateParameter(valid_594498, JString, required = true,
                                 default = nil)
  if valid_594498 != nil:
    section.add "linkedServiceName", valid_594498
  var valid_594499 = path.getOrDefault("subscriptionId")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "subscriptionId", valid_594499
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594500 = query.getOrDefault("api-version")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "api-version", valid_594500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594501: Call_LinkedServicesDelete_594493; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a linked service.
  ## 
  let valid = call_594501.validator(path, query, header, formData, body)
  let scheme = call_594501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594501.url(scheme.get, call_594501.host, call_594501.base,
                         call_594501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594501, url, valid)

proc call*(call_594502: Call_LinkedServicesDelete_594493;
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
  var path_594503 = newJObject()
  var query_594504 = newJObject()
  add(path_594503, "resourceGroupName", newJString(resourceGroupName))
  add(path_594503, "factoryName", newJString(factoryName))
  add(query_594504, "api-version", newJString(apiVersion))
  add(path_594503, "linkedServiceName", newJString(linkedServiceName))
  add(path_594503, "subscriptionId", newJString(subscriptionId))
  result = call_594502.call(path_594503, query_594504, nil, nil, nil)

var linkedServicesDelete* = Call_LinkedServicesDelete_594493(
    name: "linkedServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesDelete_594494, base: "",
    url: url_LinkedServicesDelete_594495, schemes: {Scheme.Https})
type
  Call_PipelineRunsGet_594505 = ref object of OpenApiRestCall_593439
proc url_PipelineRunsGet_594507(protocol: Scheme; host: string; base: string;
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

proc validate_PipelineRunsGet_594506(path: JsonNode; query: JsonNode;
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
  var valid_594508 = path.getOrDefault("resourceGroupName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "resourceGroupName", valid_594508
  var valid_594509 = path.getOrDefault("factoryName")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "factoryName", valid_594509
  var valid_594510 = path.getOrDefault("subscriptionId")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "subscriptionId", valid_594510
  var valid_594511 = path.getOrDefault("runId")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "runId", valid_594511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594512 = query.getOrDefault("api-version")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "api-version", valid_594512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594513: Call_PipelineRunsGet_594505; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a pipeline run by its run ID.
  ## 
  let valid = call_594513.validator(path, query, header, formData, body)
  let scheme = call_594513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594513.url(scheme.get, call_594513.host, call_594513.base,
                         call_594513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594513, url, valid)

proc call*(call_594514: Call_PipelineRunsGet_594505; resourceGroupName: string;
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
  var path_594515 = newJObject()
  var query_594516 = newJObject()
  add(path_594515, "resourceGroupName", newJString(resourceGroupName))
  add(path_594515, "factoryName", newJString(factoryName))
  add(query_594516, "api-version", newJString(apiVersion))
  add(path_594515, "subscriptionId", newJString(subscriptionId))
  add(path_594515, "runId", newJString(runId))
  result = call_594514.call(path_594515, query_594516, nil, nil, nil)

var pipelineRunsGet* = Call_PipelineRunsGet_594505(name: "pipelineRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}",
    validator: validate_PipelineRunsGet_594506, base: "", url: url_PipelineRunsGet_594507,
    schemes: {Scheme.Https})
type
  Call_PipelineRunsCancel_594517 = ref object of OpenApiRestCall_593439
proc url_PipelineRunsCancel_594519(protocol: Scheme; host: string; base: string;
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

proc validate_PipelineRunsCancel_594518(path: JsonNode; query: JsonNode;
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
  var valid_594520 = path.getOrDefault("resourceGroupName")
  valid_594520 = validateParameter(valid_594520, JString, required = true,
                                 default = nil)
  if valid_594520 != nil:
    section.add "resourceGroupName", valid_594520
  var valid_594521 = path.getOrDefault("factoryName")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "factoryName", valid_594521
  var valid_594522 = path.getOrDefault("subscriptionId")
  valid_594522 = validateParameter(valid_594522, JString, required = true,
                                 default = nil)
  if valid_594522 != nil:
    section.add "subscriptionId", valid_594522
  var valid_594523 = path.getOrDefault("runId")
  valid_594523 = validateParameter(valid_594523, JString, required = true,
                                 default = nil)
  if valid_594523 != nil:
    section.add "runId", valid_594523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   isRecursive: JBool
  ##              : If true, cancel all the Child pipelines that are triggered by the current pipeline.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594524 = query.getOrDefault("api-version")
  valid_594524 = validateParameter(valid_594524, JString, required = true,
                                 default = nil)
  if valid_594524 != nil:
    section.add "api-version", valid_594524
  var valid_594525 = query.getOrDefault("isRecursive")
  valid_594525 = validateParameter(valid_594525, JBool, required = false, default = nil)
  if valid_594525 != nil:
    section.add "isRecursive", valid_594525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594526: Call_PipelineRunsCancel_594517; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a pipeline run by its run ID.
  ## 
  let valid = call_594526.validator(path, query, header, formData, body)
  let scheme = call_594526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594526.url(scheme.get, call_594526.host, call_594526.base,
                         call_594526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594526, url, valid)

proc call*(call_594527: Call_PipelineRunsCancel_594517; resourceGroupName: string;
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
  var path_594528 = newJObject()
  var query_594529 = newJObject()
  add(path_594528, "resourceGroupName", newJString(resourceGroupName))
  add(path_594528, "factoryName", newJString(factoryName))
  add(query_594529, "api-version", newJString(apiVersion))
  add(query_594529, "isRecursive", newJBool(isRecursive))
  add(path_594528, "subscriptionId", newJString(subscriptionId))
  add(path_594528, "runId", newJString(runId))
  result = call_594527.call(path_594528, query_594529, nil, nil, nil)

var pipelineRunsCancel* = Call_PipelineRunsCancel_594517(
    name: "pipelineRunsCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}/cancel",
    validator: validate_PipelineRunsCancel_594518, base: "",
    url: url_PipelineRunsCancel_594519, schemes: {Scheme.Https})
type
  Call_ActivityRunsQueryByPipelineRun_594530 = ref object of OpenApiRestCall_593439
proc url_ActivityRunsQueryByPipelineRun_594532(protocol: Scheme; host: string;
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

proc validate_ActivityRunsQueryByPipelineRun_594531(path: JsonNode;
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
  var valid_594533 = path.getOrDefault("resourceGroupName")
  valid_594533 = validateParameter(valid_594533, JString, required = true,
                                 default = nil)
  if valid_594533 != nil:
    section.add "resourceGroupName", valid_594533
  var valid_594534 = path.getOrDefault("factoryName")
  valid_594534 = validateParameter(valid_594534, JString, required = true,
                                 default = nil)
  if valid_594534 != nil:
    section.add "factoryName", valid_594534
  var valid_594535 = path.getOrDefault("subscriptionId")
  valid_594535 = validateParameter(valid_594535, JString, required = true,
                                 default = nil)
  if valid_594535 != nil:
    section.add "subscriptionId", valid_594535
  var valid_594536 = path.getOrDefault("runId")
  valid_594536 = validateParameter(valid_594536, JString, required = true,
                                 default = nil)
  if valid_594536 != nil:
    section.add "runId", valid_594536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594537 = query.getOrDefault("api-version")
  valid_594537 = validateParameter(valid_594537, JString, required = true,
                                 default = nil)
  if valid_594537 != nil:
    section.add "api-version", valid_594537
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

proc call*(call_594539: Call_ActivityRunsQueryByPipelineRun_594530; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query activity runs based on input filter conditions.
  ## 
  let valid = call_594539.validator(path, query, header, formData, body)
  let scheme = call_594539.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594539.url(scheme.get, call_594539.host, call_594539.base,
                         call_594539.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594539, url, valid)

proc call*(call_594540: Call_ActivityRunsQueryByPipelineRun_594530;
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
  var path_594541 = newJObject()
  var query_594542 = newJObject()
  var body_594543 = newJObject()
  add(path_594541, "resourceGroupName", newJString(resourceGroupName))
  add(path_594541, "factoryName", newJString(factoryName))
  add(query_594542, "api-version", newJString(apiVersion))
  add(path_594541, "subscriptionId", newJString(subscriptionId))
  add(path_594541, "runId", newJString(runId))
  if filterParameters != nil:
    body_594543 = filterParameters
  result = call_594540.call(path_594541, query_594542, nil, nil, body_594543)

var activityRunsQueryByPipelineRun* = Call_ActivityRunsQueryByPipelineRun_594530(
    name: "activityRunsQueryByPipelineRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}/queryActivityruns",
    validator: validate_ActivityRunsQueryByPipelineRun_594531, base: "",
    url: url_ActivityRunsQueryByPipelineRun_594532, schemes: {Scheme.Https})
type
  Call_PipelinesListByFactory_594544 = ref object of OpenApiRestCall_593439
proc url_PipelinesListByFactory_594546(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesListByFactory_594545(path: JsonNode; query: JsonNode;
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
  var valid_594547 = path.getOrDefault("resourceGroupName")
  valid_594547 = validateParameter(valid_594547, JString, required = true,
                                 default = nil)
  if valid_594547 != nil:
    section.add "resourceGroupName", valid_594547
  var valid_594548 = path.getOrDefault("factoryName")
  valid_594548 = validateParameter(valid_594548, JString, required = true,
                                 default = nil)
  if valid_594548 != nil:
    section.add "factoryName", valid_594548
  var valid_594549 = path.getOrDefault("subscriptionId")
  valid_594549 = validateParameter(valid_594549, JString, required = true,
                                 default = nil)
  if valid_594549 != nil:
    section.add "subscriptionId", valid_594549
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594550 = query.getOrDefault("api-version")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "api-version", valid_594550
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594551: Call_PipelinesListByFactory_594544; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  let valid = call_594551.validator(path, query, header, formData, body)
  let scheme = call_594551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594551.url(scheme.get, call_594551.host, call_594551.base,
                         call_594551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594551, url, valid)

proc call*(call_594552: Call_PipelinesListByFactory_594544;
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
  var path_594553 = newJObject()
  var query_594554 = newJObject()
  add(path_594553, "resourceGroupName", newJString(resourceGroupName))
  add(path_594553, "factoryName", newJString(factoryName))
  add(query_594554, "api-version", newJString(apiVersion))
  add(path_594553, "subscriptionId", newJString(subscriptionId))
  result = call_594552.call(path_594553, query_594554, nil, nil, nil)

var pipelinesListByFactory* = Call_PipelinesListByFactory_594544(
    name: "pipelinesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines",
    validator: validate_PipelinesListByFactory_594545, base: "",
    url: url_PipelinesListByFactory_594546, schemes: {Scheme.Https})
type
  Call_PipelinesCreateOrUpdate_594568 = ref object of OpenApiRestCall_593439
proc url_PipelinesCreateOrUpdate_594570(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesCreateOrUpdate_594569(path: JsonNode; query: JsonNode;
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
  var valid_594571 = path.getOrDefault("resourceGroupName")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "resourceGroupName", valid_594571
  var valid_594572 = path.getOrDefault("factoryName")
  valid_594572 = validateParameter(valid_594572, JString, required = true,
                                 default = nil)
  if valid_594572 != nil:
    section.add "factoryName", valid_594572
  var valid_594573 = path.getOrDefault("subscriptionId")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = nil)
  if valid_594573 != nil:
    section.add "subscriptionId", valid_594573
  var valid_594574 = path.getOrDefault("pipelineName")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "pipelineName", valid_594574
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594575 = query.getOrDefault("api-version")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "api-version", valid_594575
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the pipeline entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594576 = header.getOrDefault("If-Match")
  valid_594576 = validateParameter(valid_594576, JString, required = false,
                                 default = nil)
  if valid_594576 != nil:
    section.add "If-Match", valid_594576
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

proc call*(call_594578: Call_PipelinesCreateOrUpdate_594568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a pipeline.
  ## 
  let valid = call_594578.validator(path, query, header, formData, body)
  let scheme = call_594578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594578.url(scheme.get, call_594578.host, call_594578.base,
                         call_594578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594578, url, valid)

proc call*(call_594579: Call_PipelinesCreateOrUpdate_594568;
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
  var path_594580 = newJObject()
  var query_594581 = newJObject()
  var body_594582 = newJObject()
  add(path_594580, "resourceGroupName", newJString(resourceGroupName))
  add(path_594580, "factoryName", newJString(factoryName))
  add(query_594581, "api-version", newJString(apiVersion))
  if pipeline != nil:
    body_594582 = pipeline
  add(path_594580, "subscriptionId", newJString(subscriptionId))
  add(path_594580, "pipelineName", newJString(pipelineName))
  result = call_594579.call(path_594580, query_594581, nil, nil, body_594582)

var pipelinesCreateOrUpdate* = Call_PipelinesCreateOrUpdate_594568(
    name: "pipelinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesCreateOrUpdate_594569, base: "",
    url: url_PipelinesCreateOrUpdate_594570, schemes: {Scheme.Https})
type
  Call_PipelinesGet_594555 = ref object of OpenApiRestCall_593439
proc url_PipelinesGet_594557(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesGet_594556(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594558 = path.getOrDefault("resourceGroupName")
  valid_594558 = validateParameter(valid_594558, JString, required = true,
                                 default = nil)
  if valid_594558 != nil:
    section.add "resourceGroupName", valid_594558
  var valid_594559 = path.getOrDefault("factoryName")
  valid_594559 = validateParameter(valid_594559, JString, required = true,
                                 default = nil)
  if valid_594559 != nil:
    section.add "factoryName", valid_594559
  var valid_594560 = path.getOrDefault("subscriptionId")
  valid_594560 = validateParameter(valid_594560, JString, required = true,
                                 default = nil)
  if valid_594560 != nil:
    section.add "subscriptionId", valid_594560
  var valid_594561 = path.getOrDefault("pipelineName")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "pipelineName", valid_594561
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594562 = query.getOrDefault("api-version")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "api-version", valid_594562
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the pipeline entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_594563 = header.getOrDefault("If-None-Match")
  valid_594563 = validateParameter(valid_594563, JString, required = false,
                                 default = nil)
  if valid_594563 != nil:
    section.add "If-None-Match", valid_594563
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594564: Call_PipelinesGet_594555; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a pipeline.
  ## 
  let valid = call_594564.validator(path, query, header, formData, body)
  let scheme = call_594564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594564.url(scheme.get, call_594564.host, call_594564.base,
                         call_594564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594564, url, valid)

proc call*(call_594565: Call_PipelinesGet_594555; resourceGroupName: string;
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
  var path_594566 = newJObject()
  var query_594567 = newJObject()
  add(path_594566, "resourceGroupName", newJString(resourceGroupName))
  add(path_594566, "factoryName", newJString(factoryName))
  add(query_594567, "api-version", newJString(apiVersion))
  add(path_594566, "subscriptionId", newJString(subscriptionId))
  add(path_594566, "pipelineName", newJString(pipelineName))
  result = call_594565.call(path_594566, query_594567, nil, nil, nil)

var pipelinesGet* = Call_PipelinesGet_594555(name: "pipelinesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesGet_594556, base: "", url: url_PipelinesGet_594557,
    schemes: {Scheme.Https})
type
  Call_PipelinesDelete_594583 = ref object of OpenApiRestCall_593439
proc url_PipelinesDelete_594585(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesDelete_594584(path: JsonNode; query: JsonNode;
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
  var valid_594586 = path.getOrDefault("resourceGroupName")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "resourceGroupName", valid_594586
  var valid_594587 = path.getOrDefault("factoryName")
  valid_594587 = validateParameter(valid_594587, JString, required = true,
                                 default = nil)
  if valid_594587 != nil:
    section.add "factoryName", valid_594587
  var valid_594588 = path.getOrDefault("subscriptionId")
  valid_594588 = validateParameter(valid_594588, JString, required = true,
                                 default = nil)
  if valid_594588 != nil:
    section.add "subscriptionId", valid_594588
  var valid_594589 = path.getOrDefault("pipelineName")
  valid_594589 = validateParameter(valid_594589, JString, required = true,
                                 default = nil)
  if valid_594589 != nil:
    section.add "pipelineName", valid_594589
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594590 = query.getOrDefault("api-version")
  valid_594590 = validateParameter(valid_594590, JString, required = true,
                                 default = nil)
  if valid_594590 != nil:
    section.add "api-version", valid_594590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594591: Call_PipelinesDelete_594583; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline.
  ## 
  let valid = call_594591.validator(path, query, header, formData, body)
  let scheme = call_594591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594591.url(scheme.get, call_594591.host, call_594591.base,
                         call_594591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594591, url, valid)

proc call*(call_594592: Call_PipelinesDelete_594583; resourceGroupName: string;
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
  var path_594593 = newJObject()
  var query_594594 = newJObject()
  add(path_594593, "resourceGroupName", newJString(resourceGroupName))
  add(path_594593, "factoryName", newJString(factoryName))
  add(query_594594, "api-version", newJString(apiVersion))
  add(path_594593, "subscriptionId", newJString(subscriptionId))
  add(path_594593, "pipelineName", newJString(pipelineName))
  result = call_594592.call(path_594593, query_594594, nil, nil, nil)

var pipelinesDelete* = Call_PipelinesDelete_594583(name: "pipelinesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesDelete_594584, base: "", url: url_PipelinesDelete_594585,
    schemes: {Scheme.Https})
type
  Call_PipelinesCreateRun_594595 = ref object of OpenApiRestCall_593439
proc url_PipelinesCreateRun_594597(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesCreateRun_594596(path: JsonNode; query: JsonNode;
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
  var valid_594598 = path.getOrDefault("resourceGroupName")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "resourceGroupName", valid_594598
  var valid_594599 = path.getOrDefault("factoryName")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "factoryName", valid_594599
  var valid_594600 = path.getOrDefault("subscriptionId")
  valid_594600 = validateParameter(valid_594600, JString, required = true,
                                 default = nil)
  if valid_594600 != nil:
    section.add "subscriptionId", valid_594600
  var valid_594601 = path.getOrDefault("pipelineName")
  valid_594601 = validateParameter(valid_594601, JString, required = true,
                                 default = nil)
  if valid_594601 != nil:
    section.add "pipelineName", valid_594601
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
  var valid_594602 = query.getOrDefault("api-version")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = nil)
  if valid_594602 != nil:
    section.add "api-version", valid_594602
  var valid_594603 = query.getOrDefault("referencePipelineRunId")
  valid_594603 = validateParameter(valid_594603, JString, required = false,
                                 default = nil)
  if valid_594603 != nil:
    section.add "referencePipelineRunId", valid_594603
  var valid_594604 = query.getOrDefault("startActivityName")
  valid_594604 = validateParameter(valid_594604, JString, required = false,
                                 default = nil)
  if valid_594604 != nil:
    section.add "startActivityName", valid_594604
  var valid_594605 = query.getOrDefault("isRecovery")
  valid_594605 = validateParameter(valid_594605, JBool, required = false, default = nil)
  if valid_594605 != nil:
    section.add "isRecovery", valid_594605
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

proc call*(call_594607: Call_PipelinesCreateRun_594595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a run of a pipeline.
  ## 
  let valid = call_594607.validator(path, query, header, formData, body)
  let scheme = call_594607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594607.url(scheme.get, call_594607.host, call_594607.base,
                         call_594607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594607, url, valid)

proc call*(call_594608: Call_PipelinesCreateRun_594595; resourceGroupName: string;
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
  var path_594609 = newJObject()
  var query_594610 = newJObject()
  var body_594611 = newJObject()
  add(path_594609, "resourceGroupName", newJString(resourceGroupName))
  add(path_594609, "factoryName", newJString(factoryName))
  add(query_594610, "api-version", newJString(apiVersion))
  add(path_594609, "subscriptionId", newJString(subscriptionId))
  add(query_594610, "referencePipelineRunId", newJString(referencePipelineRunId))
  add(path_594609, "pipelineName", newJString(pipelineName))
  add(query_594610, "startActivityName", newJString(startActivityName))
  add(query_594610, "isRecovery", newJBool(isRecovery))
  if parameters != nil:
    body_594611 = parameters
  result = call_594608.call(path_594609, query_594610, nil, nil, body_594611)

var pipelinesCreateRun* = Call_PipelinesCreateRun_594595(
    name: "pipelinesCreateRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}/createRun",
    validator: validate_PipelinesCreateRun_594596, base: "",
    url: url_PipelinesCreateRun_594597, schemes: {Scheme.Https})
type
  Call_PipelineRunsQueryByFactory_594612 = ref object of OpenApiRestCall_593439
proc url_PipelineRunsQueryByFactory_594614(protocol: Scheme; host: string;
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

proc validate_PipelineRunsQueryByFactory_594613(path: JsonNode; query: JsonNode;
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
  var valid_594615 = path.getOrDefault("resourceGroupName")
  valid_594615 = validateParameter(valid_594615, JString, required = true,
                                 default = nil)
  if valid_594615 != nil:
    section.add "resourceGroupName", valid_594615
  var valid_594616 = path.getOrDefault("factoryName")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "factoryName", valid_594616
  var valid_594617 = path.getOrDefault("subscriptionId")
  valid_594617 = validateParameter(valid_594617, JString, required = true,
                                 default = nil)
  if valid_594617 != nil:
    section.add "subscriptionId", valid_594617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594618 = query.getOrDefault("api-version")
  valid_594618 = validateParameter(valid_594618, JString, required = true,
                                 default = nil)
  if valid_594618 != nil:
    section.add "api-version", valid_594618
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

proc call*(call_594620: Call_PipelineRunsQueryByFactory_594612; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query pipeline runs in the factory based on input filter conditions.
  ## 
  let valid = call_594620.validator(path, query, header, formData, body)
  let scheme = call_594620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594620.url(scheme.get, call_594620.host, call_594620.base,
                         call_594620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594620, url, valid)

proc call*(call_594621: Call_PipelineRunsQueryByFactory_594612;
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
  var path_594622 = newJObject()
  var query_594623 = newJObject()
  var body_594624 = newJObject()
  add(path_594622, "resourceGroupName", newJString(resourceGroupName))
  add(path_594622, "factoryName", newJString(factoryName))
  add(query_594623, "api-version", newJString(apiVersion))
  add(path_594622, "subscriptionId", newJString(subscriptionId))
  if filterParameters != nil:
    body_594624 = filterParameters
  result = call_594621.call(path_594622, query_594623, nil, nil, body_594624)

var pipelineRunsQueryByFactory* = Call_PipelineRunsQueryByFactory_594612(
    name: "pipelineRunsQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/queryPipelineRuns",
    validator: validate_PipelineRunsQueryByFactory_594613, base: "",
    url: url_PipelineRunsQueryByFactory_594614, schemes: {Scheme.Https})
type
  Call_TriggerRunsQueryByFactory_594625 = ref object of OpenApiRestCall_593439
proc url_TriggerRunsQueryByFactory_594627(protocol: Scheme; host: string;
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

proc validate_TriggerRunsQueryByFactory_594626(path: JsonNode; query: JsonNode;
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
  var valid_594628 = path.getOrDefault("resourceGroupName")
  valid_594628 = validateParameter(valid_594628, JString, required = true,
                                 default = nil)
  if valid_594628 != nil:
    section.add "resourceGroupName", valid_594628
  var valid_594629 = path.getOrDefault("factoryName")
  valid_594629 = validateParameter(valid_594629, JString, required = true,
                                 default = nil)
  if valid_594629 != nil:
    section.add "factoryName", valid_594629
  var valid_594630 = path.getOrDefault("subscriptionId")
  valid_594630 = validateParameter(valid_594630, JString, required = true,
                                 default = nil)
  if valid_594630 != nil:
    section.add "subscriptionId", valid_594630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594631 = query.getOrDefault("api-version")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "api-version", valid_594631
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

proc call*(call_594633: Call_TriggerRunsQueryByFactory_594625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query trigger runs.
  ## 
  let valid = call_594633.validator(path, query, header, formData, body)
  let scheme = call_594633.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594633.url(scheme.get, call_594633.host, call_594633.base,
                         call_594633.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594633, url, valid)

proc call*(call_594634: Call_TriggerRunsQueryByFactory_594625;
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
  var path_594635 = newJObject()
  var query_594636 = newJObject()
  var body_594637 = newJObject()
  add(path_594635, "resourceGroupName", newJString(resourceGroupName))
  add(path_594635, "factoryName", newJString(factoryName))
  add(query_594636, "api-version", newJString(apiVersion))
  add(path_594635, "subscriptionId", newJString(subscriptionId))
  if filterParameters != nil:
    body_594637 = filterParameters
  result = call_594634.call(path_594635, query_594636, nil, nil, body_594637)

var triggerRunsQueryByFactory* = Call_TriggerRunsQueryByFactory_594625(
    name: "triggerRunsQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/queryTriggerRuns",
    validator: validate_TriggerRunsQueryByFactory_594626, base: "",
    url: url_TriggerRunsQueryByFactory_594627, schemes: {Scheme.Https})
type
  Call_TriggersListByFactory_594638 = ref object of OpenApiRestCall_593439
proc url_TriggersListByFactory_594640(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersListByFactory_594639(path: JsonNode; query: JsonNode;
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
  var valid_594641 = path.getOrDefault("resourceGroupName")
  valid_594641 = validateParameter(valid_594641, JString, required = true,
                                 default = nil)
  if valid_594641 != nil:
    section.add "resourceGroupName", valid_594641
  var valid_594642 = path.getOrDefault("factoryName")
  valid_594642 = validateParameter(valid_594642, JString, required = true,
                                 default = nil)
  if valid_594642 != nil:
    section.add "factoryName", valid_594642
  var valid_594643 = path.getOrDefault("subscriptionId")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "subscriptionId", valid_594643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594644 = query.getOrDefault("api-version")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "api-version", valid_594644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594645: Call_TriggersListByFactory_594638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists triggers.
  ## 
  let valid = call_594645.validator(path, query, header, formData, body)
  let scheme = call_594645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594645.url(scheme.get, call_594645.host, call_594645.base,
                         call_594645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594645, url, valid)

proc call*(call_594646: Call_TriggersListByFactory_594638;
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
  var path_594647 = newJObject()
  var query_594648 = newJObject()
  add(path_594647, "resourceGroupName", newJString(resourceGroupName))
  add(path_594647, "factoryName", newJString(factoryName))
  add(query_594648, "api-version", newJString(apiVersion))
  add(path_594647, "subscriptionId", newJString(subscriptionId))
  result = call_594646.call(path_594647, query_594648, nil, nil, nil)

var triggersListByFactory* = Call_TriggersListByFactory_594638(
    name: "triggersListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers",
    validator: validate_TriggersListByFactory_594639, base: "",
    url: url_TriggersListByFactory_594640, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_594662 = ref object of OpenApiRestCall_593439
proc url_TriggersCreateOrUpdate_594664(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreateOrUpdate_594663(path: JsonNode; query: JsonNode;
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
  var valid_594665 = path.getOrDefault("resourceGroupName")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "resourceGroupName", valid_594665
  var valid_594666 = path.getOrDefault("factoryName")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "factoryName", valid_594666
  var valid_594667 = path.getOrDefault("subscriptionId")
  valid_594667 = validateParameter(valid_594667, JString, required = true,
                                 default = nil)
  if valid_594667 != nil:
    section.add "subscriptionId", valid_594667
  var valid_594668 = path.getOrDefault("triggerName")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = nil)
  if valid_594668 != nil:
    section.add "triggerName", valid_594668
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594669 = query.getOrDefault("api-version")
  valid_594669 = validateParameter(valid_594669, JString, required = true,
                                 default = nil)
  if valid_594669 != nil:
    section.add "api-version", valid_594669
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the trigger entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_594670 = header.getOrDefault("If-Match")
  valid_594670 = validateParameter(valid_594670, JString, required = false,
                                 default = nil)
  if valid_594670 != nil:
    section.add "If-Match", valid_594670
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

proc call*(call_594672: Call_TriggersCreateOrUpdate_594662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_594672.validator(path, query, header, formData, body)
  let scheme = call_594672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594672.url(scheme.get, call_594672.host, call_594672.base,
                         call_594672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594672, url, valid)

proc call*(call_594673: Call_TriggersCreateOrUpdate_594662;
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
  var path_594674 = newJObject()
  var query_594675 = newJObject()
  var body_594676 = newJObject()
  add(path_594674, "resourceGroupName", newJString(resourceGroupName))
  add(path_594674, "factoryName", newJString(factoryName))
  add(query_594675, "api-version", newJString(apiVersion))
  add(path_594674, "subscriptionId", newJString(subscriptionId))
  if trigger != nil:
    body_594676 = trigger
  add(path_594674, "triggerName", newJString(triggerName))
  result = call_594673.call(path_594674, query_594675, nil, nil, body_594676)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_594662(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersCreateOrUpdate_594663, base: "",
    url: url_TriggersCreateOrUpdate_594664, schemes: {Scheme.Https})
type
  Call_TriggersGet_594649 = ref object of OpenApiRestCall_593439
proc url_TriggersGet_594651(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_594650(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594652 = path.getOrDefault("resourceGroupName")
  valid_594652 = validateParameter(valid_594652, JString, required = true,
                                 default = nil)
  if valid_594652 != nil:
    section.add "resourceGroupName", valid_594652
  var valid_594653 = path.getOrDefault("factoryName")
  valid_594653 = validateParameter(valid_594653, JString, required = true,
                                 default = nil)
  if valid_594653 != nil:
    section.add "factoryName", valid_594653
  var valid_594654 = path.getOrDefault("subscriptionId")
  valid_594654 = validateParameter(valid_594654, JString, required = true,
                                 default = nil)
  if valid_594654 != nil:
    section.add "subscriptionId", valid_594654
  var valid_594655 = path.getOrDefault("triggerName")
  valid_594655 = validateParameter(valid_594655, JString, required = true,
                                 default = nil)
  if valid_594655 != nil:
    section.add "triggerName", valid_594655
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594656 = query.getOrDefault("api-version")
  valid_594656 = validateParameter(valid_594656, JString, required = true,
                                 default = nil)
  if valid_594656 != nil:
    section.add "api-version", valid_594656
  result.add "query", section
  ## parameters in `header` object:
  ##   If-None-Match: JString
  ##                : ETag of the trigger entity. Should only be specified for get. If the ETag matches the existing entity tag, or if * was provided, then no content will be returned.
  section = newJObject()
  var valid_594657 = header.getOrDefault("If-None-Match")
  valid_594657 = validateParameter(valid_594657, JString, required = false,
                                 default = nil)
  if valid_594657 != nil:
    section.add "If-None-Match", valid_594657
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594658: Call_TriggersGet_594649; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a trigger.
  ## 
  let valid = call_594658.validator(path, query, header, formData, body)
  let scheme = call_594658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594658.url(scheme.get, call_594658.host, call_594658.base,
                         call_594658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594658, url, valid)

proc call*(call_594659: Call_TriggersGet_594649; resourceGroupName: string;
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
  var path_594660 = newJObject()
  var query_594661 = newJObject()
  add(path_594660, "resourceGroupName", newJString(resourceGroupName))
  add(path_594660, "factoryName", newJString(factoryName))
  add(query_594661, "api-version", newJString(apiVersion))
  add(path_594660, "subscriptionId", newJString(subscriptionId))
  add(path_594660, "triggerName", newJString(triggerName))
  result = call_594659.call(path_594660, query_594661, nil, nil, nil)

var triggersGet* = Call_TriggersGet_594649(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
                                        validator: validate_TriggersGet_594650,
                                        base: "", url: url_TriggersGet_594651,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_594677 = ref object of OpenApiRestCall_593439
proc url_TriggersDelete_594679(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_594678(path: JsonNode; query: JsonNode;
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
  var valid_594680 = path.getOrDefault("resourceGroupName")
  valid_594680 = validateParameter(valid_594680, JString, required = true,
                                 default = nil)
  if valid_594680 != nil:
    section.add "resourceGroupName", valid_594680
  var valid_594681 = path.getOrDefault("factoryName")
  valid_594681 = validateParameter(valid_594681, JString, required = true,
                                 default = nil)
  if valid_594681 != nil:
    section.add "factoryName", valid_594681
  var valid_594682 = path.getOrDefault("subscriptionId")
  valid_594682 = validateParameter(valid_594682, JString, required = true,
                                 default = nil)
  if valid_594682 != nil:
    section.add "subscriptionId", valid_594682
  var valid_594683 = path.getOrDefault("triggerName")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "triggerName", valid_594683
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594684 = query.getOrDefault("api-version")
  valid_594684 = validateParameter(valid_594684, JString, required = true,
                                 default = nil)
  if valid_594684 != nil:
    section.add "api-version", valid_594684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594685: Call_TriggersDelete_594677; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a trigger.
  ## 
  let valid = call_594685.validator(path, query, header, formData, body)
  let scheme = call_594685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594685.url(scheme.get, call_594685.host, call_594685.base,
                         call_594685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594685, url, valid)

proc call*(call_594686: Call_TriggersDelete_594677; resourceGroupName: string;
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
  var path_594687 = newJObject()
  var query_594688 = newJObject()
  add(path_594687, "resourceGroupName", newJString(resourceGroupName))
  add(path_594687, "factoryName", newJString(factoryName))
  add(query_594688, "api-version", newJString(apiVersion))
  add(path_594687, "subscriptionId", newJString(subscriptionId))
  add(path_594687, "triggerName", newJString(triggerName))
  result = call_594686.call(path_594687, query_594688, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_594677(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersDelete_594678, base: "", url: url_TriggersDelete_594679,
    schemes: {Scheme.Https})
type
  Call_TriggersGetEventSubscriptionStatus_594689 = ref object of OpenApiRestCall_593439
proc url_TriggersGetEventSubscriptionStatus_594691(protocol: Scheme; host: string;
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

proc validate_TriggersGetEventSubscriptionStatus_594690(path: JsonNode;
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
  var valid_594692 = path.getOrDefault("resourceGroupName")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = nil)
  if valid_594692 != nil:
    section.add "resourceGroupName", valid_594692
  var valid_594693 = path.getOrDefault("factoryName")
  valid_594693 = validateParameter(valid_594693, JString, required = true,
                                 default = nil)
  if valid_594693 != nil:
    section.add "factoryName", valid_594693
  var valid_594694 = path.getOrDefault("subscriptionId")
  valid_594694 = validateParameter(valid_594694, JString, required = true,
                                 default = nil)
  if valid_594694 != nil:
    section.add "subscriptionId", valid_594694
  var valid_594695 = path.getOrDefault("triggerName")
  valid_594695 = validateParameter(valid_594695, JString, required = true,
                                 default = nil)
  if valid_594695 != nil:
    section.add "triggerName", valid_594695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594696 = query.getOrDefault("api-version")
  valid_594696 = validateParameter(valid_594696, JString, required = true,
                                 default = nil)
  if valid_594696 != nil:
    section.add "api-version", valid_594696
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594697: Call_TriggersGetEventSubscriptionStatus_594689;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a trigger's event subscription status.
  ## 
  let valid = call_594697.validator(path, query, header, formData, body)
  let scheme = call_594697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594697.url(scheme.get, call_594697.host, call_594697.base,
                         call_594697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594697, url, valid)

proc call*(call_594698: Call_TriggersGetEventSubscriptionStatus_594689;
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
  var path_594699 = newJObject()
  var query_594700 = newJObject()
  add(path_594699, "resourceGroupName", newJString(resourceGroupName))
  add(path_594699, "factoryName", newJString(factoryName))
  add(query_594700, "api-version", newJString(apiVersion))
  add(path_594699, "subscriptionId", newJString(subscriptionId))
  add(path_594699, "triggerName", newJString(triggerName))
  result = call_594698.call(path_594699, query_594700, nil, nil, nil)

var triggersGetEventSubscriptionStatus* = Call_TriggersGetEventSubscriptionStatus_594689(
    name: "triggersGetEventSubscriptionStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/getEventSubscriptionStatus",
    validator: validate_TriggersGetEventSubscriptionStatus_594690, base: "",
    url: url_TriggersGetEventSubscriptionStatus_594691, schemes: {Scheme.Https})
type
  Call_RerunTriggersListByTrigger_594701 = ref object of OpenApiRestCall_593439
proc url_RerunTriggersListByTrigger_594703(protocol: Scheme; host: string;
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

proc validate_RerunTriggersListByTrigger_594702(path: JsonNode; query: JsonNode;
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
  var valid_594704 = path.getOrDefault("resourceGroupName")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = nil)
  if valid_594704 != nil:
    section.add "resourceGroupName", valid_594704
  var valid_594705 = path.getOrDefault("factoryName")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = nil)
  if valid_594705 != nil:
    section.add "factoryName", valid_594705
  var valid_594706 = path.getOrDefault("subscriptionId")
  valid_594706 = validateParameter(valid_594706, JString, required = true,
                                 default = nil)
  if valid_594706 != nil:
    section.add "subscriptionId", valid_594706
  var valid_594707 = path.getOrDefault("triggerName")
  valid_594707 = validateParameter(valid_594707, JString, required = true,
                                 default = nil)
  if valid_594707 != nil:
    section.add "triggerName", valid_594707
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594708 = query.getOrDefault("api-version")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "api-version", valid_594708
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594709: Call_RerunTriggersListByTrigger_594701; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists rerun triggers by an original trigger name.
  ## 
  let valid = call_594709.validator(path, query, header, formData, body)
  let scheme = call_594709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594709.url(scheme.get, call_594709.host, call_594709.base,
                         call_594709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594709, url, valid)

proc call*(call_594710: Call_RerunTriggersListByTrigger_594701;
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
  var path_594711 = newJObject()
  var query_594712 = newJObject()
  add(path_594711, "resourceGroupName", newJString(resourceGroupName))
  add(path_594711, "factoryName", newJString(factoryName))
  add(query_594712, "api-version", newJString(apiVersion))
  add(path_594711, "subscriptionId", newJString(subscriptionId))
  add(path_594711, "triggerName", newJString(triggerName))
  result = call_594710.call(path_594711, query_594712, nil, nil, nil)

var rerunTriggersListByTrigger* = Call_RerunTriggersListByTrigger_594701(
    name: "rerunTriggersListByTrigger", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers",
    validator: validate_RerunTriggersListByTrigger_594702, base: "",
    url: url_RerunTriggersListByTrigger_594703, schemes: {Scheme.Https})
type
  Call_RerunTriggersCreate_594713 = ref object of OpenApiRestCall_593439
proc url_RerunTriggersCreate_594715(protocol: Scheme; host: string; base: string;
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

proc validate_RerunTriggersCreate_594714(path: JsonNode; query: JsonNode;
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
  var valid_594716 = path.getOrDefault("resourceGroupName")
  valid_594716 = validateParameter(valid_594716, JString, required = true,
                                 default = nil)
  if valid_594716 != nil:
    section.add "resourceGroupName", valid_594716
  var valid_594717 = path.getOrDefault("factoryName")
  valid_594717 = validateParameter(valid_594717, JString, required = true,
                                 default = nil)
  if valid_594717 != nil:
    section.add "factoryName", valid_594717
  var valid_594718 = path.getOrDefault("subscriptionId")
  valid_594718 = validateParameter(valid_594718, JString, required = true,
                                 default = nil)
  if valid_594718 != nil:
    section.add "subscriptionId", valid_594718
  var valid_594719 = path.getOrDefault("rerunTriggerName")
  valid_594719 = validateParameter(valid_594719, JString, required = true,
                                 default = nil)
  if valid_594719 != nil:
    section.add "rerunTriggerName", valid_594719
  var valid_594720 = path.getOrDefault("triggerName")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "triggerName", valid_594720
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594721 = query.getOrDefault("api-version")
  valid_594721 = validateParameter(valid_594721, JString, required = true,
                                 default = nil)
  if valid_594721 != nil:
    section.add "api-version", valid_594721
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

proc call*(call_594723: Call_RerunTriggersCreate_594713; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a rerun trigger.
  ## 
  let valid = call_594723.validator(path, query, header, formData, body)
  let scheme = call_594723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594723.url(scheme.get, call_594723.host, call_594723.base,
                         call_594723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594723, url, valid)

proc call*(call_594724: Call_RerunTriggersCreate_594713; resourceGroupName: string;
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
  var path_594725 = newJObject()
  var query_594726 = newJObject()
  var body_594727 = newJObject()
  add(path_594725, "resourceGroupName", newJString(resourceGroupName))
  add(path_594725, "factoryName", newJString(factoryName))
  add(query_594726, "api-version", newJString(apiVersion))
  add(path_594725, "subscriptionId", newJString(subscriptionId))
  add(path_594725, "rerunTriggerName", newJString(rerunTriggerName))
  if rerunTumblingWindowTriggerActionParameters != nil:
    body_594727 = rerunTumblingWindowTriggerActionParameters
  add(path_594725, "triggerName", newJString(triggerName))
  result = call_594724.call(path_594725, query_594726, nil, nil, body_594727)

var rerunTriggersCreate* = Call_RerunTriggersCreate_594713(
    name: "rerunTriggersCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}",
    validator: validate_RerunTriggersCreate_594714, base: "",
    url: url_RerunTriggersCreate_594715, schemes: {Scheme.Https})
type
  Call_RerunTriggersCancel_594728 = ref object of OpenApiRestCall_593439
proc url_RerunTriggersCancel_594730(protocol: Scheme; host: string; base: string;
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

proc validate_RerunTriggersCancel_594729(path: JsonNode; query: JsonNode;
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
  var valid_594731 = path.getOrDefault("resourceGroupName")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = nil)
  if valid_594731 != nil:
    section.add "resourceGroupName", valid_594731
  var valid_594732 = path.getOrDefault("factoryName")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "factoryName", valid_594732
  var valid_594733 = path.getOrDefault("subscriptionId")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "subscriptionId", valid_594733
  var valid_594734 = path.getOrDefault("rerunTriggerName")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "rerunTriggerName", valid_594734
  var valid_594735 = path.getOrDefault("triggerName")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "triggerName", valid_594735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594736 = query.getOrDefault("api-version")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "api-version", valid_594736
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594737: Call_RerunTriggersCancel_594728; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels a trigger.
  ## 
  let valid = call_594737.validator(path, query, header, formData, body)
  let scheme = call_594737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594737.url(scheme.get, call_594737.host, call_594737.base,
                         call_594737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594737, url, valid)

proc call*(call_594738: Call_RerunTriggersCancel_594728; resourceGroupName: string;
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
  var path_594739 = newJObject()
  var query_594740 = newJObject()
  add(path_594739, "resourceGroupName", newJString(resourceGroupName))
  add(path_594739, "factoryName", newJString(factoryName))
  add(query_594740, "api-version", newJString(apiVersion))
  add(path_594739, "subscriptionId", newJString(subscriptionId))
  add(path_594739, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_594739, "triggerName", newJString(triggerName))
  result = call_594738.call(path_594739, query_594740, nil, nil, nil)

var rerunTriggersCancel* = Call_RerunTriggersCancel_594728(
    name: "rerunTriggersCancel", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}/cancel",
    validator: validate_RerunTriggersCancel_594729, base: "",
    url: url_RerunTriggersCancel_594730, schemes: {Scheme.Https})
type
  Call_RerunTriggersStart_594741 = ref object of OpenApiRestCall_593439
proc url_RerunTriggersStart_594743(protocol: Scheme; host: string; base: string;
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

proc validate_RerunTriggersStart_594742(path: JsonNode; query: JsonNode;
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
  var valid_594744 = path.getOrDefault("resourceGroupName")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "resourceGroupName", valid_594744
  var valid_594745 = path.getOrDefault("factoryName")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = nil)
  if valid_594745 != nil:
    section.add "factoryName", valid_594745
  var valid_594746 = path.getOrDefault("subscriptionId")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "subscriptionId", valid_594746
  var valid_594747 = path.getOrDefault("rerunTriggerName")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = nil)
  if valid_594747 != nil:
    section.add "rerunTriggerName", valid_594747
  var valid_594748 = path.getOrDefault("triggerName")
  valid_594748 = validateParameter(valid_594748, JString, required = true,
                                 default = nil)
  if valid_594748 != nil:
    section.add "triggerName", valid_594748
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594749 = query.getOrDefault("api-version")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "api-version", valid_594749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594750: Call_RerunTriggersStart_594741; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a trigger.
  ## 
  let valid = call_594750.validator(path, query, header, formData, body)
  let scheme = call_594750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594750.url(scheme.get, call_594750.host, call_594750.base,
                         call_594750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594750, url, valid)

proc call*(call_594751: Call_RerunTriggersStart_594741; resourceGroupName: string;
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
  var path_594752 = newJObject()
  var query_594753 = newJObject()
  add(path_594752, "resourceGroupName", newJString(resourceGroupName))
  add(path_594752, "factoryName", newJString(factoryName))
  add(query_594753, "api-version", newJString(apiVersion))
  add(path_594752, "subscriptionId", newJString(subscriptionId))
  add(path_594752, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_594752, "triggerName", newJString(triggerName))
  result = call_594751.call(path_594752, query_594753, nil, nil, nil)

var rerunTriggersStart* = Call_RerunTriggersStart_594741(
    name: "rerunTriggersStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}/start",
    validator: validate_RerunTriggersStart_594742, base: "",
    url: url_RerunTriggersStart_594743, schemes: {Scheme.Https})
type
  Call_RerunTriggersStop_594754 = ref object of OpenApiRestCall_593439
proc url_RerunTriggersStop_594756(protocol: Scheme; host: string; base: string;
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

proc validate_RerunTriggersStop_594755(path: JsonNode; query: JsonNode;
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
  var valid_594757 = path.getOrDefault("resourceGroupName")
  valid_594757 = validateParameter(valid_594757, JString, required = true,
                                 default = nil)
  if valid_594757 != nil:
    section.add "resourceGroupName", valid_594757
  var valid_594758 = path.getOrDefault("factoryName")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = nil)
  if valid_594758 != nil:
    section.add "factoryName", valid_594758
  var valid_594759 = path.getOrDefault("subscriptionId")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "subscriptionId", valid_594759
  var valid_594760 = path.getOrDefault("rerunTriggerName")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "rerunTriggerName", valid_594760
  var valid_594761 = path.getOrDefault("triggerName")
  valid_594761 = validateParameter(valid_594761, JString, required = true,
                                 default = nil)
  if valid_594761 != nil:
    section.add "triggerName", valid_594761
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594762 = query.getOrDefault("api-version")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "api-version", valid_594762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594763: Call_RerunTriggersStop_594754; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a trigger.
  ## 
  let valid = call_594763.validator(path, query, header, formData, body)
  let scheme = call_594763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594763.url(scheme.get, call_594763.host, call_594763.base,
                         call_594763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594763, url, valid)

proc call*(call_594764: Call_RerunTriggersStop_594754; resourceGroupName: string;
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
  var path_594765 = newJObject()
  var query_594766 = newJObject()
  add(path_594765, "resourceGroupName", newJString(resourceGroupName))
  add(path_594765, "factoryName", newJString(factoryName))
  add(query_594766, "api-version", newJString(apiVersion))
  add(path_594765, "subscriptionId", newJString(subscriptionId))
  add(path_594765, "rerunTriggerName", newJString(rerunTriggerName))
  add(path_594765, "triggerName", newJString(triggerName))
  result = call_594764.call(path_594765, query_594766, nil, nil, nil)

var rerunTriggersStop* = Call_RerunTriggersStop_594754(name: "rerunTriggersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/rerunTriggers/{rerunTriggerName}/stop",
    validator: validate_RerunTriggersStop_594755, base: "",
    url: url_RerunTriggersStop_594756, schemes: {Scheme.Https})
type
  Call_TriggersStart_594767 = ref object of OpenApiRestCall_593439
proc url_TriggersStart_594769(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersStart_594768(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594770 = path.getOrDefault("resourceGroupName")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "resourceGroupName", valid_594770
  var valid_594771 = path.getOrDefault("factoryName")
  valid_594771 = validateParameter(valid_594771, JString, required = true,
                                 default = nil)
  if valid_594771 != nil:
    section.add "factoryName", valid_594771
  var valid_594772 = path.getOrDefault("subscriptionId")
  valid_594772 = validateParameter(valid_594772, JString, required = true,
                                 default = nil)
  if valid_594772 != nil:
    section.add "subscriptionId", valid_594772
  var valid_594773 = path.getOrDefault("triggerName")
  valid_594773 = validateParameter(valid_594773, JString, required = true,
                                 default = nil)
  if valid_594773 != nil:
    section.add "triggerName", valid_594773
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594774 = query.getOrDefault("api-version")
  valid_594774 = validateParameter(valid_594774, JString, required = true,
                                 default = nil)
  if valid_594774 != nil:
    section.add "api-version", valid_594774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594775: Call_TriggersStart_594767; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a trigger.
  ## 
  let valid = call_594775.validator(path, query, header, formData, body)
  let scheme = call_594775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594775.url(scheme.get, call_594775.host, call_594775.base,
                         call_594775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594775, url, valid)

proc call*(call_594776: Call_TriggersStart_594767; resourceGroupName: string;
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
  var path_594777 = newJObject()
  var query_594778 = newJObject()
  add(path_594777, "resourceGroupName", newJString(resourceGroupName))
  add(path_594777, "factoryName", newJString(factoryName))
  add(query_594778, "api-version", newJString(apiVersion))
  add(path_594777, "subscriptionId", newJString(subscriptionId))
  add(path_594777, "triggerName", newJString(triggerName))
  result = call_594776.call(path_594777, query_594778, nil, nil, nil)

var triggersStart* = Call_TriggersStart_594767(name: "triggersStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/start",
    validator: validate_TriggersStart_594768, base: "", url: url_TriggersStart_594769,
    schemes: {Scheme.Https})
type
  Call_TriggersStop_594779 = ref object of OpenApiRestCall_593439
proc url_TriggersStop_594781(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersStop_594780(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594782 = path.getOrDefault("resourceGroupName")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "resourceGroupName", valid_594782
  var valid_594783 = path.getOrDefault("factoryName")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "factoryName", valid_594783
  var valid_594784 = path.getOrDefault("subscriptionId")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "subscriptionId", valid_594784
  var valid_594785 = path.getOrDefault("triggerName")
  valid_594785 = validateParameter(valid_594785, JString, required = true,
                                 default = nil)
  if valid_594785 != nil:
    section.add "triggerName", valid_594785
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594786 = query.getOrDefault("api-version")
  valid_594786 = validateParameter(valid_594786, JString, required = true,
                                 default = nil)
  if valid_594786 != nil:
    section.add "api-version", valid_594786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594787: Call_TriggersStop_594779; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a trigger.
  ## 
  let valid = call_594787.validator(path, query, header, formData, body)
  let scheme = call_594787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594787.url(scheme.get, call_594787.host, call_594787.base,
                         call_594787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594787, url, valid)

proc call*(call_594788: Call_TriggersStop_594779; resourceGroupName: string;
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
  var path_594789 = newJObject()
  var query_594790 = newJObject()
  add(path_594789, "resourceGroupName", newJString(resourceGroupName))
  add(path_594789, "factoryName", newJString(factoryName))
  add(query_594790, "api-version", newJString(apiVersion))
  add(path_594789, "subscriptionId", newJString(subscriptionId))
  add(path_594789, "triggerName", newJString(triggerName))
  result = call_594788.call(path_594789, query_594790, nil, nil, nil)

var triggersStop* = Call_TriggersStop_594779(name: "triggersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/stop",
    validator: validate_TriggersStop_594780, base: "", url: url_TriggersStop_594781,
    schemes: {Scheme.Https})
type
  Call_TriggersSubscribeToEvents_594791 = ref object of OpenApiRestCall_593439
proc url_TriggersSubscribeToEvents_594793(protocol: Scheme; host: string;
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

proc validate_TriggersSubscribeToEvents_594792(path: JsonNode; query: JsonNode;
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
  var valid_594794 = path.getOrDefault("resourceGroupName")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "resourceGroupName", valid_594794
  var valid_594795 = path.getOrDefault("factoryName")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "factoryName", valid_594795
  var valid_594796 = path.getOrDefault("subscriptionId")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "subscriptionId", valid_594796
  var valid_594797 = path.getOrDefault("triggerName")
  valid_594797 = validateParameter(valid_594797, JString, required = true,
                                 default = nil)
  if valid_594797 != nil:
    section.add "triggerName", valid_594797
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594798 = query.getOrDefault("api-version")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = nil)
  if valid_594798 != nil:
    section.add "api-version", valid_594798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594799: Call_TriggersSubscribeToEvents_594791; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Subscribe event trigger to events.
  ## 
  let valid = call_594799.validator(path, query, header, formData, body)
  let scheme = call_594799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594799.url(scheme.get, call_594799.host, call_594799.base,
                         call_594799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594799, url, valid)

proc call*(call_594800: Call_TriggersSubscribeToEvents_594791;
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
  var path_594801 = newJObject()
  var query_594802 = newJObject()
  add(path_594801, "resourceGroupName", newJString(resourceGroupName))
  add(path_594801, "factoryName", newJString(factoryName))
  add(query_594802, "api-version", newJString(apiVersion))
  add(path_594801, "subscriptionId", newJString(subscriptionId))
  add(path_594801, "triggerName", newJString(triggerName))
  result = call_594800.call(path_594801, query_594802, nil, nil, nil)

var triggersSubscribeToEvents* = Call_TriggersSubscribeToEvents_594791(
    name: "triggersSubscribeToEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/subscribeToEvents",
    validator: validate_TriggersSubscribeToEvents_594792, base: "",
    url: url_TriggersSubscribeToEvents_594793, schemes: {Scheme.Https})
type
  Call_TriggerRunsRerun_594803 = ref object of OpenApiRestCall_593439
proc url_TriggerRunsRerun_594805(protocol: Scheme; host: string; base: string;
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

proc validate_TriggerRunsRerun_594804(path: JsonNode; query: JsonNode;
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
  var valid_594806 = path.getOrDefault("resourceGroupName")
  valid_594806 = validateParameter(valid_594806, JString, required = true,
                                 default = nil)
  if valid_594806 != nil:
    section.add "resourceGroupName", valid_594806
  var valid_594807 = path.getOrDefault("factoryName")
  valid_594807 = validateParameter(valid_594807, JString, required = true,
                                 default = nil)
  if valid_594807 != nil:
    section.add "factoryName", valid_594807
  var valid_594808 = path.getOrDefault("subscriptionId")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "subscriptionId", valid_594808
  var valid_594809 = path.getOrDefault("runId")
  valid_594809 = validateParameter(valid_594809, JString, required = true,
                                 default = nil)
  if valid_594809 != nil:
    section.add "runId", valid_594809
  var valid_594810 = path.getOrDefault("triggerName")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "triggerName", valid_594810
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594811 = query.getOrDefault("api-version")
  valid_594811 = validateParameter(valid_594811, JString, required = true,
                                 default = nil)
  if valid_594811 != nil:
    section.add "api-version", valid_594811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594812: Call_TriggerRunsRerun_594803; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rerun single trigger instance by runId.
  ## 
  let valid = call_594812.validator(path, query, header, formData, body)
  let scheme = call_594812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594812.url(scheme.get, call_594812.host, call_594812.base,
                         call_594812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594812, url, valid)

proc call*(call_594813: Call_TriggerRunsRerun_594803; resourceGroupName: string;
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
  var path_594814 = newJObject()
  var query_594815 = newJObject()
  add(path_594814, "resourceGroupName", newJString(resourceGroupName))
  add(path_594814, "factoryName", newJString(factoryName))
  add(query_594815, "api-version", newJString(apiVersion))
  add(path_594814, "subscriptionId", newJString(subscriptionId))
  add(path_594814, "runId", newJString(runId))
  add(path_594814, "triggerName", newJString(triggerName))
  result = call_594813.call(path_594814, query_594815, nil, nil, nil)

var triggerRunsRerun* = Call_TriggerRunsRerun_594803(name: "triggerRunsRerun",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/triggerRuns/{runId}/rerun",
    validator: validate_TriggerRunsRerun_594804, base: "",
    url: url_TriggerRunsRerun_594805, schemes: {Scheme.Https})
type
  Call_TriggersUnsubscribeFromEvents_594816 = ref object of OpenApiRestCall_593439
proc url_TriggersUnsubscribeFromEvents_594818(protocol: Scheme; host: string;
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

proc validate_TriggersUnsubscribeFromEvents_594817(path: JsonNode; query: JsonNode;
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
  var valid_594819 = path.getOrDefault("resourceGroupName")
  valid_594819 = validateParameter(valid_594819, JString, required = true,
                                 default = nil)
  if valid_594819 != nil:
    section.add "resourceGroupName", valid_594819
  var valid_594820 = path.getOrDefault("factoryName")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "factoryName", valid_594820
  var valid_594821 = path.getOrDefault("subscriptionId")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "subscriptionId", valid_594821
  var valid_594822 = path.getOrDefault("triggerName")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "triggerName", valid_594822
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594823 = query.getOrDefault("api-version")
  valid_594823 = validateParameter(valid_594823, JString, required = true,
                                 default = nil)
  if valid_594823 != nil:
    section.add "api-version", valid_594823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594824: Call_TriggersUnsubscribeFromEvents_594816; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unsubscribe event trigger from events.
  ## 
  let valid = call_594824.validator(path, query, header, formData, body)
  let scheme = call_594824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594824.url(scheme.get, call_594824.host, call_594824.base,
                         call_594824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594824, url, valid)

proc call*(call_594825: Call_TriggersUnsubscribeFromEvents_594816;
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
  var path_594826 = newJObject()
  var query_594827 = newJObject()
  add(path_594826, "resourceGroupName", newJString(resourceGroupName))
  add(path_594826, "factoryName", newJString(factoryName))
  add(query_594827, "api-version", newJString(apiVersion))
  add(path_594826, "subscriptionId", newJString(subscriptionId))
  add(path_594826, "triggerName", newJString(triggerName))
  result = call_594825.call(path_594826, query_594827, nil, nil, nil)

var triggersUnsubscribeFromEvents* = Call_TriggersUnsubscribeFromEvents_594816(
    name: "triggersUnsubscribeFromEvents", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/unsubscribeFromEvents",
    validator: validate_TriggersUnsubscribeFromEvents_594817, base: "",
    url: url_TriggersUnsubscribeFromEvents_594818, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
