
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: DataFactoryManagementClient
## version: 2017-09-01-preview
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
  Call_FactoriesListByResourceGroup_564138 = ref object of OpenApiRestCall_563566
proc url_FactoriesListByResourceGroup_564140(protocol: Scheme; host: string;
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

proc validate_FactoriesListByResourceGroup_564139(path: JsonNode; query: JsonNode;
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
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("resourceGroupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceGroupName", valid_564142
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
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_FactoriesListByResourceGroup_564138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists factories.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_FactoriesListByResourceGroup_564138;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## factoriesListByResourceGroup
  ## Lists factories.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var factoriesListByResourceGroup* = Call_FactoriesListByResourceGroup_564138(
    name: "factoriesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories",
    validator: validate_FactoriesListByResourceGroup_564139, base: "",
    url: url_FactoriesListByResourceGroup_564140, schemes: {Scheme.Https})
type
  Call_FactoriesCreateOrUpdate_564159 = ref object of OpenApiRestCall_563566
proc url_FactoriesCreateOrUpdate_564161(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesCreateOrUpdate_564160(path: JsonNode; query: JsonNode;
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
  var valid_564162 = path.getOrDefault("subscriptionId")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "subscriptionId", valid_564162
  var valid_564163 = path.getOrDefault("resourceGroupName")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "resourceGroupName", valid_564163
  var valid_564164 = path.getOrDefault("factoryName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "factoryName", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564165 = query.getOrDefault("api-version")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "api-version", valid_564165
  result.add "query", section
  section = newJObject()
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

proc call*(call_564167: Call_FactoriesCreateOrUpdate_564159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a factory.
  ## 
  let valid = call_564167.validator(path, query, header, formData, body)
  let scheme = call_564167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564167.url(scheme.get, call_564167.host, call_564167.base,
                         call_564167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564167, url, valid)

proc call*(call_564168: Call_FactoriesCreateOrUpdate_564159; apiVersion: string;
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
  var path_564169 = newJObject()
  var query_564170 = newJObject()
  var body_564171 = newJObject()
  add(query_564170, "api-version", newJString(apiVersion))
  add(path_564169, "subscriptionId", newJString(subscriptionId))
  if factory != nil:
    body_564171 = factory
  add(path_564169, "resourceGroupName", newJString(resourceGroupName))
  add(path_564169, "factoryName", newJString(factoryName))
  result = call_564168.call(path_564169, query_564170, nil, nil, body_564171)

var factoriesCreateOrUpdate* = Call_FactoriesCreateOrUpdate_564159(
    name: "factoriesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesCreateOrUpdate_564160, base: "",
    url: url_FactoriesCreateOrUpdate_564161, schemes: {Scheme.Https})
type
  Call_FactoriesGet_564148 = ref object of OpenApiRestCall_563566
proc url_FactoriesGet_564150(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesGet_564149(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564153 = path.getOrDefault("factoryName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "factoryName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_FactoriesGet_564148; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a factory.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_FactoriesGet_564148; apiVersion: string;
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
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  add(path_564157, "factoryName", newJString(factoryName))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var factoriesGet* = Call_FactoriesGet_564148(name: "factoriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesGet_564149, base: "", url: url_FactoriesGet_564150,
    schemes: {Scheme.Https})
type
  Call_FactoriesUpdate_564183 = ref object of OpenApiRestCall_563566
proc url_FactoriesUpdate_564185(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesUpdate_564184(path: JsonNode; query: JsonNode;
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
  var valid_564186 = path.getOrDefault("subscriptionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "subscriptionId", valid_564186
  var valid_564187 = path.getOrDefault("resourceGroupName")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "resourceGroupName", valid_564187
  var valid_564188 = path.getOrDefault("factoryName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "factoryName", valid_564188
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564189 = query.getOrDefault("api-version")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "api-version", valid_564189
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

proc call*(call_564191: Call_FactoriesUpdate_564183; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a factory.
  ## 
  let valid = call_564191.validator(path, query, header, formData, body)
  let scheme = call_564191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564191.url(scheme.get, call_564191.host, call_564191.base,
                         call_564191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564191, url, valid)

proc call*(call_564192: Call_FactoriesUpdate_564183; apiVersion: string;
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
  var path_564193 = newJObject()
  var query_564194 = newJObject()
  var body_564195 = newJObject()
  add(query_564194, "api-version", newJString(apiVersion))
  add(path_564193, "subscriptionId", newJString(subscriptionId))
  add(path_564193, "resourceGroupName", newJString(resourceGroupName))
  if factoryUpdateParameters != nil:
    body_564195 = factoryUpdateParameters
  add(path_564193, "factoryName", newJString(factoryName))
  result = call_564192.call(path_564193, query_564194, nil, nil, body_564195)

var factoriesUpdate* = Call_FactoriesUpdate_564183(name: "factoriesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesUpdate_564184, base: "", url: url_FactoriesUpdate_564185,
    schemes: {Scheme.Https})
type
  Call_FactoriesDelete_564172 = ref object of OpenApiRestCall_563566
proc url_FactoriesDelete_564174(protocol: Scheme; host: string; base: string;
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

proc validate_FactoriesDelete_564173(path: JsonNode; query: JsonNode;
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
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564179: Call_FactoriesDelete_564172; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a factory.
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_FactoriesDelete_564172; apiVersion: string;
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
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  add(query_564182, "api-version", newJString(apiVersion))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  add(path_564181, "factoryName", newJString(factoryName))
  result = call_564180.call(path_564181, query_564182, nil, nil, nil)

var factoriesDelete* = Call_FactoriesDelete_564172(name: "factoriesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}",
    validator: validate_FactoriesDelete_564173, base: "", url: url_FactoriesDelete_564174,
    schemes: {Scheme.Https})
type
  Call_FactoriesCancelPipelineRun_564196 = ref object of OpenApiRestCall_563566
proc url_FactoriesCancelPipelineRun_564198(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/cancelpipelinerun/"),
               (kind: VariableSegment, value: "runId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FactoriesCancelPipelineRun_564197(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_564199 = path.getOrDefault("runId")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "runId", valid_564199
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
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_FactoriesCancelPipelineRun_564196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancel a pipeline run by its run ID.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_FactoriesCancelPipelineRun_564196; runId: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          factoryName: string): Recallable =
  ## factoriesCancelPipelineRun
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
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  add(path_564206, "runId", newJString(runId))
  add(query_564207, "api-version", newJString(apiVersion))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(path_564206, "resourceGroupName", newJString(resourceGroupName))
  add(path_564206, "factoryName", newJString(factoryName))
  result = call_564205.call(path_564206, query_564207, nil, nil, nil)

var factoriesCancelPipelineRun* = Call_FactoriesCancelPipelineRun_564196(
    name: "factoriesCancelPipelineRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/cancelpipelinerun/{runId}",
    validator: validate_FactoriesCancelPipelineRun_564197, base: "",
    url: url_FactoriesCancelPipelineRun_564198, schemes: {Scheme.Https})
type
  Call_DatasetsListByFactory_564208 = ref object of OpenApiRestCall_563566
proc url_DatasetsListByFactory_564210(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsListByFactory_564209(path: JsonNode; query: JsonNode;
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
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("resourceGroupName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "resourceGroupName", valid_564212
  var valid_564213 = path.getOrDefault("factoryName")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "factoryName", valid_564213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564214 = query.getOrDefault("api-version")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "api-version", valid_564214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564215: Call_DatasetsListByFactory_564208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists datasets.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_DatasetsListByFactory_564208; apiVersion: string;
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
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  add(query_564218, "api-version", newJString(apiVersion))
  add(path_564217, "subscriptionId", newJString(subscriptionId))
  add(path_564217, "resourceGroupName", newJString(resourceGroupName))
  add(path_564217, "factoryName", newJString(factoryName))
  result = call_564216.call(path_564217, query_564218, nil, nil, nil)

var datasetsListByFactory* = Call_DatasetsListByFactory_564208(
    name: "datasetsListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets",
    validator: validate_DatasetsListByFactory_564209, base: "",
    url: url_DatasetsListByFactory_564210, schemes: {Scheme.Https})
type
  Call_DatasetsCreateOrUpdate_564231 = ref object of OpenApiRestCall_563566
proc url_DatasetsCreateOrUpdate_564233(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsCreateOrUpdate_564232(path: JsonNode; query: JsonNode;
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
  var valid_564234 = path.getOrDefault("datasetName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "datasetName", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  var valid_564236 = path.getOrDefault("resourceGroupName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "resourceGroupName", valid_564236
  var valid_564237 = path.getOrDefault("factoryName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "factoryName", valid_564237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564238 = query.getOrDefault("api-version")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "api-version", valid_564238
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the dataset entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564239 = header.getOrDefault("If-Match")
  valid_564239 = validateParameter(valid_564239, JString, required = false,
                                 default = nil)
  if valid_564239 != nil:
    section.add "If-Match", valid_564239
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

proc call*(call_564241: Call_DatasetsCreateOrUpdate_564231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a dataset.
  ## 
  let valid = call_564241.validator(path, query, header, formData, body)
  let scheme = call_564241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564241.url(scheme.get, call_564241.host, call_564241.base,
                         call_564241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564241, url, valid)

proc call*(call_564242: Call_DatasetsCreateOrUpdate_564231; dataset: JsonNode;
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
  var path_564243 = newJObject()
  var query_564244 = newJObject()
  var body_564245 = newJObject()
  if dataset != nil:
    body_564245 = dataset
  add(query_564244, "api-version", newJString(apiVersion))
  add(path_564243, "datasetName", newJString(datasetName))
  add(path_564243, "subscriptionId", newJString(subscriptionId))
  add(path_564243, "resourceGroupName", newJString(resourceGroupName))
  add(path_564243, "factoryName", newJString(factoryName))
  result = call_564242.call(path_564243, query_564244, nil, nil, body_564245)

var datasetsCreateOrUpdate* = Call_DatasetsCreateOrUpdate_564231(
    name: "datasetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsCreateOrUpdate_564232, base: "",
    url: url_DatasetsCreateOrUpdate_564233, schemes: {Scheme.Https})
type
  Call_DatasetsGet_564219 = ref object of OpenApiRestCall_563566
proc url_DatasetsGet_564221(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsGet_564220(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564222 = path.getOrDefault("datasetName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "datasetName", valid_564222
  var valid_564223 = path.getOrDefault("subscriptionId")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "subscriptionId", valid_564223
  var valid_564224 = path.getOrDefault("resourceGroupName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "resourceGroupName", valid_564224
  var valid_564225 = path.getOrDefault("factoryName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "factoryName", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_DatasetsGet_564219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a dataset.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_DatasetsGet_564219; apiVersion: string;
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
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "datasetName", newJString(datasetName))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  add(path_564229, "resourceGroupName", newJString(resourceGroupName))
  add(path_564229, "factoryName", newJString(factoryName))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var datasetsGet* = Call_DatasetsGet_564219(name: "datasetsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
                                        validator: validate_DatasetsGet_564220,
                                        base: "", url: url_DatasetsGet_564221,
                                        schemes: {Scheme.Https})
type
  Call_DatasetsDelete_564246 = ref object of OpenApiRestCall_563566
proc url_DatasetsDelete_564248(protocol: Scheme; host: string; base: string;
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

proc validate_DatasetsDelete_564247(path: JsonNode; query: JsonNode;
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
  var valid_564249 = path.getOrDefault("datasetName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "datasetName", valid_564249
  var valid_564250 = path.getOrDefault("subscriptionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "subscriptionId", valid_564250
  var valid_564251 = path.getOrDefault("resourceGroupName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "resourceGroupName", valid_564251
  var valid_564252 = path.getOrDefault("factoryName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "factoryName", valid_564252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564253 = query.getOrDefault("api-version")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "api-version", valid_564253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564254: Call_DatasetsDelete_564246; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a dataset.
  ## 
  let valid = call_564254.validator(path, query, header, formData, body)
  let scheme = call_564254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564254.url(scheme.get, call_564254.host, call_564254.base,
                         call_564254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564254, url, valid)

proc call*(call_564255: Call_DatasetsDelete_564246; apiVersion: string;
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
  var path_564256 = newJObject()
  var query_564257 = newJObject()
  add(query_564257, "api-version", newJString(apiVersion))
  add(path_564256, "datasetName", newJString(datasetName))
  add(path_564256, "subscriptionId", newJString(subscriptionId))
  add(path_564256, "resourceGroupName", newJString(resourceGroupName))
  add(path_564256, "factoryName", newJString(factoryName))
  result = call_564255.call(path_564256, query_564257, nil, nil, nil)

var datasetsDelete* = Call_DatasetsDelete_564246(name: "datasetsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/datasets/{datasetName}",
    validator: validate_DatasetsDelete_564247, base: "", url: url_DatasetsDelete_564248,
    schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListByFactory_564258 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesListByFactory_564260(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesListByFactory_564259(path: JsonNode;
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
  var valid_564261 = path.getOrDefault("subscriptionId")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "subscriptionId", valid_564261
  var valid_564262 = path.getOrDefault("resourceGroupName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "resourceGroupName", valid_564262
  var valid_564263 = path.getOrDefault("factoryName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "factoryName", valid_564263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564264 = query.getOrDefault("api-version")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "api-version", valid_564264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564265: Call_IntegrationRuntimesListByFactory_564258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists integration runtimes.
  ## 
  let valid = call_564265.validator(path, query, header, formData, body)
  let scheme = call_564265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564265.url(scheme.get, call_564265.host, call_564265.base,
                         call_564265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564265, url, valid)

proc call*(call_564266: Call_IntegrationRuntimesListByFactory_564258;
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
  var path_564267 = newJObject()
  var query_564268 = newJObject()
  add(query_564268, "api-version", newJString(apiVersion))
  add(path_564267, "subscriptionId", newJString(subscriptionId))
  add(path_564267, "resourceGroupName", newJString(resourceGroupName))
  add(path_564267, "factoryName", newJString(factoryName))
  result = call_564266.call(path_564267, query_564268, nil, nil, nil)

var integrationRuntimesListByFactory* = Call_IntegrationRuntimesListByFactory_564258(
    name: "integrationRuntimesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes",
    validator: validate_IntegrationRuntimesListByFactory_564259, base: "",
    url: url_IntegrationRuntimesListByFactory_564260, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesCreateOrUpdate_564281 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesCreateOrUpdate_564283(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesCreateOrUpdate_564282(path: JsonNode;
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
  var valid_564284 = path.getOrDefault("integrationRuntimeName")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "integrationRuntimeName", valid_564284
  var valid_564285 = path.getOrDefault("subscriptionId")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "subscriptionId", valid_564285
  var valid_564286 = path.getOrDefault("resourceGroupName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "resourceGroupName", valid_564286
  var valid_564287 = path.getOrDefault("factoryName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "factoryName", valid_564287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564288 = query.getOrDefault("api-version")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "api-version", valid_564288
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the integration runtime entity. Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564289 = header.getOrDefault("If-Match")
  valid_564289 = validateParameter(valid_564289, JString, required = false,
                                 default = nil)
  if valid_564289 != nil:
    section.add "If-Match", valid_564289
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

proc call*(call_564291: Call_IntegrationRuntimesCreateOrUpdate_564281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates an integration runtime.
  ## 
  let valid = call_564291.validator(path, query, header, formData, body)
  let scheme = call_564291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564291.url(scheme.get, call_564291.host, call_564291.base,
                         call_564291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564291, url, valid)

proc call*(call_564292: Call_IntegrationRuntimesCreateOrUpdate_564281;
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
  var path_564293 = newJObject()
  var query_564294 = newJObject()
  var body_564295 = newJObject()
  add(query_564294, "api-version", newJString(apiVersion))
  add(path_564293, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564293, "subscriptionId", newJString(subscriptionId))
  add(path_564293, "resourceGroupName", newJString(resourceGroupName))
  add(path_564293, "factoryName", newJString(factoryName))
  if integrationRuntime != nil:
    body_564295 = integrationRuntime
  result = call_564292.call(path_564293, query_564294, nil, nil, body_564295)

var integrationRuntimesCreateOrUpdate* = Call_IntegrationRuntimesCreateOrUpdate_564281(
    name: "integrationRuntimesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesCreateOrUpdate_564282, base: "",
    url: url_IntegrationRuntimesCreateOrUpdate_564283, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGet_564269 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesGet_564271(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationRuntimesGet_564270(path: JsonNode; query: JsonNode;
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
  var valid_564272 = path.getOrDefault("integrationRuntimeName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "integrationRuntimeName", valid_564272
  var valid_564273 = path.getOrDefault("subscriptionId")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "subscriptionId", valid_564273
  var valid_564274 = path.getOrDefault("resourceGroupName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "resourceGroupName", valid_564274
  var valid_564275 = path.getOrDefault("factoryName")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "factoryName", valid_564275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564276 = query.getOrDefault("api-version")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "api-version", valid_564276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_IntegrationRuntimesGet_564269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an integration runtime.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_IntegrationRuntimesGet_564269; apiVersion: string;
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
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564279, "subscriptionId", newJString(subscriptionId))
  add(path_564279, "resourceGroupName", newJString(resourceGroupName))
  add(path_564279, "factoryName", newJString(factoryName))
  result = call_564278.call(path_564279, query_564280, nil, nil, nil)

var integrationRuntimesGet* = Call_IntegrationRuntimesGet_564269(
    name: "integrationRuntimesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesGet_564270, base: "",
    url: url_IntegrationRuntimesGet_564271, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpdate_564308 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesUpdate_564310(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesUpdate_564309(path: JsonNode; query: JsonNode;
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
  var valid_564311 = path.getOrDefault("integrationRuntimeName")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "integrationRuntimeName", valid_564311
  var valid_564312 = path.getOrDefault("subscriptionId")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "subscriptionId", valid_564312
  var valid_564313 = path.getOrDefault("resourceGroupName")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "resourceGroupName", valid_564313
  var valid_564314 = path.getOrDefault("factoryName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "factoryName", valid_564314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564315 = query.getOrDefault("api-version")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "api-version", valid_564315
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

proc call*(call_564317: Call_IntegrationRuntimesUpdate_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an integration runtime.
  ## 
  let valid = call_564317.validator(path, query, header, formData, body)
  let scheme = call_564317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564317.url(scheme.get, call_564317.host, call_564317.base,
                         call_564317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564317, url, valid)

proc call*(call_564318: Call_IntegrationRuntimesUpdate_564308; apiVersion: string;
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
  var path_564319 = newJObject()
  var query_564320 = newJObject()
  var body_564321 = newJObject()
  add(query_564320, "api-version", newJString(apiVersion))
  add(path_564319, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564319, "subscriptionId", newJString(subscriptionId))
  add(path_564319, "resourceGroupName", newJString(resourceGroupName))
  add(path_564319, "factoryName", newJString(factoryName))
  if updateIntegrationRuntimeRequest != nil:
    body_564321 = updateIntegrationRuntimeRequest
  result = call_564318.call(path_564319, query_564320, nil, nil, body_564321)

var integrationRuntimesUpdate* = Call_IntegrationRuntimesUpdate_564308(
    name: "integrationRuntimesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesUpdate_564309, base: "",
    url: url_IntegrationRuntimesUpdate_564310, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesDelete_564296 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesDelete_564298(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesDelete_564297(path: JsonNode; query: JsonNode;
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
  var valid_564299 = path.getOrDefault("integrationRuntimeName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "integrationRuntimeName", valid_564299
  var valid_564300 = path.getOrDefault("subscriptionId")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "subscriptionId", valid_564300
  var valid_564301 = path.getOrDefault("resourceGroupName")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "resourceGroupName", valid_564301
  var valid_564302 = path.getOrDefault("factoryName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "factoryName", valid_564302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564303 = query.getOrDefault("api-version")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "api-version", valid_564303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564304: Call_IntegrationRuntimesDelete_564296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an integration runtime.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_IntegrationRuntimesDelete_564296; apiVersion: string;
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
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  add(path_564306, "resourceGroupName", newJString(resourceGroupName))
  add(path_564306, "factoryName", newJString(factoryName))
  result = call_564305.call(path_564306, query_564307, nil, nil, nil)

var integrationRuntimesDelete* = Call_IntegrationRuntimesDelete_564296(
    name: "integrationRuntimesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}",
    validator: validate_IntegrationRuntimesDelete_564297, base: "",
    url: url_IntegrationRuntimesDelete_564298, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetConnectionInfo_564322 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesGetConnectionInfo_564324(protocol: Scheme;
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

proc validate_IntegrationRuntimesGetConnectionInfo_564323(path: JsonNode;
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
  var valid_564325 = path.getOrDefault("integrationRuntimeName")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = nil)
  if valid_564325 != nil:
    section.add "integrationRuntimeName", valid_564325
  var valid_564326 = path.getOrDefault("subscriptionId")
  valid_564326 = validateParameter(valid_564326, JString, required = true,
                                 default = nil)
  if valid_564326 != nil:
    section.add "subscriptionId", valid_564326
  var valid_564327 = path.getOrDefault("resourceGroupName")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "resourceGroupName", valid_564327
  var valid_564328 = path.getOrDefault("factoryName")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "factoryName", valid_564328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564329 = query.getOrDefault("api-version")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "api-version", valid_564329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564330: Call_IntegrationRuntimesGetConnectionInfo_564322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the on-premises integration runtime connection information for encrypting the on-premises data source credentials.
  ## 
  let valid = call_564330.validator(path, query, header, formData, body)
  let scheme = call_564330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564330.url(scheme.get, call_564330.host, call_564330.base,
                         call_564330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564330, url, valid)

proc call*(call_564331: Call_IntegrationRuntimesGetConnectionInfo_564322;
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
  var path_564332 = newJObject()
  var query_564333 = newJObject()
  add(query_564333, "api-version", newJString(apiVersion))
  add(path_564332, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564332, "subscriptionId", newJString(subscriptionId))
  add(path_564332, "resourceGroupName", newJString(resourceGroupName))
  add(path_564332, "factoryName", newJString(factoryName))
  result = call_564331.call(path_564332, query_564333, nil, nil, nil)

var integrationRuntimesGetConnectionInfo* = Call_IntegrationRuntimesGetConnectionInfo_564322(
    name: "integrationRuntimesGetConnectionInfo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getConnectionInfo",
    validator: validate_IntegrationRuntimesGetConnectionInfo_564323, base: "",
    url: url_IntegrationRuntimesGetConnectionInfo_564324, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetStatus_564334 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesGetStatus_564336(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesGetStatus_564335(path: JsonNode; query: JsonNode;
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
  var valid_564337 = path.getOrDefault("integrationRuntimeName")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "integrationRuntimeName", valid_564337
  var valid_564338 = path.getOrDefault("subscriptionId")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "subscriptionId", valid_564338
  var valid_564339 = path.getOrDefault("resourceGroupName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "resourceGroupName", valid_564339
  var valid_564340 = path.getOrDefault("factoryName")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = nil)
  if valid_564340 != nil:
    section.add "factoryName", valid_564340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564341 = query.getOrDefault("api-version")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "api-version", valid_564341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564342: Call_IntegrationRuntimesGetStatus_564334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets detailed status information for an integration runtime.
  ## 
  let valid = call_564342.validator(path, query, header, formData, body)
  let scheme = call_564342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564342.url(scheme.get, call_564342.host, call_564342.base,
                         call_564342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564342, url, valid)

proc call*(call_564343: Call_IntegrationRuntimesGetStatus_564334;
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
  var path_564344 = newJObject()
  var query_564345 = newJObject()
  add(query_564345, "api-version", newJString(apiVersion))
  add(path_564344, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564344, "subscriptionId", newJString(subscriptionId))
  add(path_564344, "resourceGroupName", newJString(resourceGroupName))
  add(path_564344, "factoryName", newJString(factoryName))
  result = call_564343.call(path_564344, query_564345, nil, nil, nil)

var integrationRuntimesGetStatus* = Call_IntegrationRuntimesGetStatus_564334(
    name: "integrationRuntimesGetStatus", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/getStatus",
    validator: validate_IntegrationRuntimesGetStatus_564335, base: "",
    url: url_IntegrationRuntimesGetStatus_564336, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesListAuthKeys_564346 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesListAuthKeys_564348(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesListAuthKeys_564347(path: JsonNode;
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
  var valid_564349 = path.getOrDefault("integrationRuntimeName")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "integrationRuntimeName", valid_564349
  var valid_564350 = path.getOrDefault("subscriptionId")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "subscriptionId", valid_564350
  var valid_564351 = path.getOrDefault("resourceGroupName")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "resourceGroupName", valid_564351
  var valid_564352 = path.getOrDefault("factoryName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "factoryName", valid_564352
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564353 = query.getOrDefault("api-version")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "api-version", valid_564353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564354: Call_IntegrationRuntimesListAuthKeys_564346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the authentication keys for an integration runtime.
  ## 
  let valid = call_564354.validator(path, query, header, formData, body)
  let scheme = call_564354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564354.url(scheme.get, call_564354.host, call_564354.base,
                         call_564354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564354, url, valid)

proc call*(call_564355: Call_IntegrationRuntimesListAuthKeys_564346;
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
  var path_564356 = newJObject()
  var query_564357 = newJObject()
  add(query_564357, "api-version", newJString(apiVersion))
  add(path_564356, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564356, "subscriptionId", newJString(subscriptionId))
  add(path_564356, "resourceGroupName", newJString(resourceGroupName))
  add(path_564356, "factoryName", newJString(factoryName))
  result = call_564355.call(path_564356, query_564357, nil, nil, nil)

var integrationRuntimesListAuthKeys* = Call_IntegrationRuntimesListAuthKeys_564346(
    name: "integrationRuntimesListAuthKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/listAuthKeys",
    validator: validate_IntegrationRuntimesListAuthKeys_564347, base: "",
    url: url_IntegrationRuntimesListAuthKeys_564348, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesGetMonitoringData_564358 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesGetMonitoringData_564360(protocol: Scheme;
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

proc validate_IntegrationRuntimesGetMonitoringData_564359(path: JsonNode;
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
  var valid_564361 = path.getOrDefault("integrationRuntimeName")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "integrationRuntimeName", valid_564361
  var valid_564362 = path.getOrDefault("subscriptionId")
  valid_564362 = validateParameter(valid_564362, JString, required = true,
                                 default = nil)
  if valid_564362 != nil:
    section.add "subscriptionId", valid_564362
  var valid_564363 = path.getOrDefault("resourceGroupName")
  valid_564363 = validateParameter(valid_564363, JString, required = true,
                                 default = nil)
  if valid_564363 != nil:
    section.add "resourceGroupName", valid_564363
  var valid_564364 = path.getOrDefault("factoryName")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "factoryName", valid_564364
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564365 = query.getOrDefault("api-version")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "api-version", valid_564365
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564366: Call_IntegrationRuntimesGetMonitoringData_564358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the integration runtime monitoring data, which includes the monitor data for all the nodes under this integration runtime.
  ## 
  let valid = call_564366.validator(path, query, header, formData, body)
  let scheme = call_564366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564366.url(scheme.get, call_564366.host, call_564366.base,
                         call_564366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564366, url, valid)

proc call*(call_564367: Call_IntegrationRuntimesGetMonitoringData_564358;
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
  var path_564368 = newJObject()
  var query_564369 = newJObject()
  add(query_564369, "api-version", newJString(apiVersion))
  add(path_564368, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564368, "subscriptionId", newJString(subscriptionId))
  add(path_564368, "resourceGroupName", newJString(resourceGroupName))
  add(path_564368, "factoryName", newJString(factoryName))
  result = call_564367.call(path_564368, query_564369, nil, nil, nil)

var integrationRuntimesGetMonitoringData* = Call_IntegrationRuntimesGetMonitoringData_564358(
    name: "integrationRuntimesGetMonitoringData", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/monitoringData",
    validator: validate_IntegrationRuntimesGetMonitoringData_564359, base: "",
    url: url_IntegrationRuntimesGetMonitoringData_564360, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesUpdate_564383 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimeNodesUpdate_564385(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesUpdate_564384(path: JsonNode; query: JsonNode;
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
  var valid_564386 = path.getOrDefault("integrationRuntimeName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "integrationRuntimeName", valid_564386
  var valid_564387 = path.getOrDefault("subscriptionId")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "subscriptionId", valid_564387
  var valid_564388 = path.getOrDefault("nodeName")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "nodeName", valid_564388
  var valid_564389 = path.getOrDefault("resourceGroupName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "resourceGroupName", valid_564389
  var valid_564390 = path.getOrDefault("factoryName")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "factoryName", valid_564390
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564391 = query.getOrDefault("api-version")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "api-version", valid_564391
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

proc call*(call_564393: Call_IntegrationRuntimeNodesUpdate_564383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a self-hosted integration runtime node.
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_IntegrationRuntimeNodesUpdate_564383;
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
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  var body_564397 = newJObject()
  add(query_564396, "api-version", newJString(apiVersion))
  add(path_564395, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564395, "subscriptionId", newJString(subscriptionId))
  add(path_564395, "nodeName", newJString(nodeName))
  if updateIntegrationRuntimeNodeRequest != nil:
    body_564397 = updateIntegrationRuntimeNodeRequest
  add(path_564395, "resourceGroupName", newJString(resourceGroupName))
  add(path_564395, "factoryName", newJString(factoryName))
  result = call_564394.call(path_564395, query_564396, nil, nil, body_564397)

var integrationRuntimeNodesUpdate* = Call_IntegrationRuntimeNodesUpdate_564383(
    name: "integrationRuntimeNodesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesUpdate_564384, base: "",
    url: url_IntegrationRuntimeNodesUpdate_564385, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesDelete_564370 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimeNodesDelete_564372(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesDelete_564371(path: JsonNode; query: JsonNode;
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
  var valid_564373 = path.getOrDefault("integrationRuntimeName")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "integrationRuntimeName", valid_564373
  var valid_564374 = path.getOrDefault("subscriptionId")
  valid_564374 = validateParameter(valid_564374, JString, required = true,
                                 default = nil)
  if valid_564374 != nil:
    section.add "subscriptionId", valid_564374
  var valid_564375 = path.getOrDefault("nodeName")
  valid_564375 = validateParameter(valid_564375, JString, required = true,
                                 default = nil)
  if valid_564375 != nil:
    section.add "nodeName", valid_564375
  var valid_564376 = path.getOrDefault("resourceGroupName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "resourceGroupName", valid_564376
  var valid_564377 = path.getOrDefault("factoryName")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "factoryName", valid_564377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564378 = query.getOrDefault("api-version")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "api-version", valid_564378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564379: Call_IntegrationRuntimeNodesDelete_564370; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a self-hosted integration runtime node.
  ## 
  let valid = call_564379.validator(path, query, header, formData, body)
  let scheme = call_564379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564379.url(scheme.get, call_564379.host, call_564379.base,
                         call_564379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564379, url, valid)

proc call*(call_564380: Call_IntegrationRuntimeNodesDelete_564370;
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
  var path_564381 = newJObject()
  var query_564382 = newJObject()
  add(query_564382, "api-version", newJString(apiVersion))
  add(path_564381, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564381, "subscriptionId", newJString(subscriptionId))
  add(path_564381, "nodeName", newJString(nodeName))
  add(path_564381, "resourceGroupName", newJString(resourceGroupName))
  add(path_564381, "factoryName", newJString(factoryName))
  result = call_564380.call(path_564381, query_564382, nil, nil, nil)

var integrationRuntimeNodesDelete* = Call_IntegrationRuntimeNodesDelete_564370(
    name: "integrationRuntimeNodesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}",
    validator: validate_IntegrationRuntimeNodesDelete_564371, base: "",
    url: url_IntegrationRuntimeNodesDelete_564372, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimeNodesGetIpAddress_564398 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimeNodesGetIpAddress_564400(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimeNodesGetIpAddress_564399(path: JsonNode;
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
  var valid_564401 = path.getOrDefault("integrationRuntimeName")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "integrationRuntimeName", valid_564401
  var valid_564402 = path.getOrDefault("subscriptionId")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "subscriptionId", valid_564402
  var valid_564403 = path.getOrDefault("nodeName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "nodeName", valid_564403
  var valid_564404 = path.getOrDefault("resourceGroupName")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "resourceGroupName", valid_564404
  var valid_564405 = path.getOrDefault("factoryName")
  valid_564405 = validateParameter(valid_564405, JString, required = true,
                                 default = nil)
  if valid_564405 != nil:
    section.add "factoryName", valid_564405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564406 = query.getOrDefault("api-version")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "api-version", valid_564406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564407: Call_IntegrationRuntimeNodesGetIpAddress_564398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the IP address of self-hosted integration runtime node.
  ## 
  let valid = call_564407.validator(path, query, header, formData, body)
  let scheme = call_564407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564407.url(scheme.get, call_564407.host, call_564407.base,
                         call_564407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564407, url, valid)

proc call*(call_564408: Call_IntegrationRuntimeNodesGetIpAddress_564398;
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
  var path_564409 = newJObject()
  var query_564410 = newJObject()
  add(query_564410, "api-version", newJString(apiVersion))
  add(path_564409, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564409, "subscriptionId", newJString(subscriptionId))
  add(path_564409, "nodeName", newJString(nodeName))
  add(path_564409, "resourceGroupName", newJString(resourceGroupName))
  add(path_564409, "factoryName", newJString(factoryName))
  result = call_564408.call(path_564409, query_564410, nil, nil, nil)

var integrationRuntimeNodesGetIpAddress* = Call_IntegrationRuntimeNodesGetIpAddress_564398(
    name: "integrationRuntimeNodesGetIpAddress", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/nodes/{nodeName}/ipAddress",
    validator: validate_IntegrationRuntimeNodesGetIpAddress_564399, base: "",
    url: url_IntegrationRuntimeNodesGetIpAddress_564400, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRegenerateAuthKey_564411 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesRegenerateAuthKey_564413(protocol: Scheme;
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

proc validate_IntegrationRuntimesRegenerateAuthKey_564412(path: JsonNode;
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
  var valid_564414 = path.getOrDefault("integrationRuntimeName")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "integrationRuntimeName", valid_564414
  var valid_564415 = path.getOrDefault("subscriptionId")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "subscriptionId", valid_564415
  var valid_564416 = path.getOrDefault("resourceGroupName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "resourceGroupName", valid_564416
  var valid_564417 = path.getOrDefault("factoryName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "factoryName", valid_564417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564418 = query.getOrDefault("api-version")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "api-version", valid_564418
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

proc call*(call_564420: Call_IntegrationRuntimesRegenerateAuthKey_564411;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the authentication key for an integration runtime.
  ## 
  let valid = call_564420.validator(path, query, header, formData, body)
  let scheme = call_564420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564420.url(scheme.get, call_564420.host, call_564420.base,
                         call_564420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564420, url, valid)

proc call*(call_564421: Call_IntegrationRuntimesRegenerateAuthKey_564411;
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
  var path_564422 = newJObject()
  var query_564423 = newJObject()
  var body_564424 = newJObject()
  add(query_564423, "api-version", newJString(apiVersion))
  add(path_564422, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564422, "subscriptionId", newJString(subscriptionId))
  if regenerateKeyParameters != nil:
    body_564424 = regenerateKeyParameters
  add(path_564422, "resourceGroupName", newJString(resourceGroupName))
  add(path_564422, "factoryName", newJString(factoryName))
  result = call_564421.call(path_564422, query_564423, nil, nil, body_564424)

var integrationRuntimesRegenerateAuthKey* = Call_IntegrationRuntimesRegenerateAuthKey_564411(
    name: "integrationRuntimesRegenerateAuthKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/regenerateAuthKey",
    validator: validate_IntegrationRuntimesRegenerateAuthKey_564412, base: "",
    url: url_IntegrationRuntimesRegenerateAuthKey_564413, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesRemoveNode_564425 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesRemoveNode_564427(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/removeNode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_IntegrationRuntimesRemoveNode_564426(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove a node from integration runtime.
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
  var valid_564428 = path.getOrDefault("integrationRuntimeName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "integrationRuntimeName", valid_564428
  var valid_564429 = path.getOrDefault("subscriptionId")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "subscriptionId", valid_564429
  var valid_564430 = path.getOrDefault("resourceGroupName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "resourceGroupName", valid_564430
  var valid_564431 = path.getOrDefault("factoryName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "factoryName", valid_564431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564432 = query.getOrDefault("api-version")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "api-version", valid_564432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   removeNodeParameters: JObject (required)
  ##                       : The name of the node to be removed from an integration runtime.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564434: Call_IntegrationRuntimesRemoveNode_564425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a node from integration runtime.
  ## 
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_IntegrationRuntimesRemoveNode_564425;
          apiVersion: string; integrationRuntimeName: string;
          subscriptionId: string; resourceGroupName: string;
          removeNodeParameters: JsonNode; factoryName: string): Recallable =
  ## integrationRuntimesRemoveNode
  ## Remove a node from integration runtime.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   integrationRuntimeName: string (required)
  ##                         : The integration runtime name.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   removeNodeParameters: JObject (required)
  ##                       : The name of the node to be removed from an integration runtime.
  ##   factoryName: string (required)
  ##              : The factory name.
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  var body_564438 = newJObject()
  add(query_564437, "api-version", newJString(apiVersion))
  add(path_564436, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564436, "subscriptionId", newJString(subscriptionId))
  add(path_564436, "resourceGroupName", newJString(resourceGroupName))
  if removeNodeParameters != nil:
    body_564438 = removeNodeParameters
  add(path_564436, "factoryName", newJString(factoryName))
  result = call_564435.call(path_564436, query_564437, nil, nil, body_564438)

var integrationRuntimesRemoveNode* = Call_IntegrationRuntimesRemoveNode_564425(
    name: "integrationRuntimesRemoveNode", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/removeNode",
    validator: validate_IntegrationRuntimesRemoveNode_564426, base: "",
    url: url_IntegrationRuntimesRemoveNode_564427, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStart_564439 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesStart_564441(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesStart_564440(path: JsonNode; query: JsonNode;
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
  var valid_564442 = path.getOrDefault("integrationRuntimeName")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "integrationRuntimeName", valid_564442
  var valid_564443 = path.getOrDefault("subscriptionId")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "subscriptionId", valid_564443
  var valid_564444 = path.getOrDefault("resourceGroupName")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "resourceGroupName", valid_564444
  var valid_564445 = path.getOrDefault("factoryName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "factoryName", valid_564445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564446 = query.getOrDefault("api-version")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "api-version", valid_564446
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564447: Call_IntegrationRuntimesStart_564439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a ManagedReserved type integration runtime.
  ## 
  let valid = call_564447.validator(path, query, header, formData, body)
  let scheme = call_564447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564447.url(scheme.get, call_564447.host, call_564447.base,
                         call_564447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564447, url, valid)

proc call*(call_564448: Call_IntegrationRuntimesStart_564439; apiVersion: string;
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
  var path_564449 = newJObject()
  var query_564450 = newJObject()
  add(query_564450, "api-version", newJString(apiVersion))
  add(path_564449, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564449, "subscriptionId", newJString(subscriptionId))
  add(path_564449, "resourceGroupName", newJString(resourceGroupName))
  add(path_564449, "factoryName", newJString(factoryName))
  result = call_564448.call(path_564449, query_564450, nil, nil, nil)

var integrationRuntimesStart* = Call_IntegrationRuntimesStart_564439(
    name: "integrationRuntimesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/start",
    validator: validate_IntegrationRuntimesStart_564440, base: "",
    url: url_IntegrationRuntimesStart_564441, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesStop_564451 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesStop_564453(protocol: Scheme; host: string; base: string;
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

proc validate_IntegrationRuntimesStop_564452(path: JsonNode; query: JsonNode;
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
  var valid_564454 = path.getOrDefault("integrationRuntimeName")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "integrationRuntimeName", valid_564454
  var valid_564455 = path.getOrDefault("subscriptionId")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "subscriptionId", valid_564455
  var valid_564456 = path.getOrDefault("resourceGroupName")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "resourceGroupName", valid_564456
  var valid_564457 = path.getOrDefault("factoryName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "factoryName", valid_564457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564458 = query.getOrDefault("api-version")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "api-version", valid_564458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564459: Call_IntegrationRuntimesStop_564451; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a ManagedReserved type integration runtime.
  ## 
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_IntegrationRuntimesStop_564451; apiVersion: string;
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
  var path_564461 = newJObject()
  var query_564462 = newJObject()
  add(query_564462, "api-version", newJString(apiVersion))
  add(path_564461, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564461, "subscriptionId", newJString(subscriptionId))
  add(path_564461, "resourceGroupName", newJString(resourceGroupName))
  add(path_564461, "factoryName", newJString(factoryName))
  result = call_564460.call(path_564461, query_564462, nil, nil, nil)

var integrationRuntimesStop* = Call_IntegrationRuntimesStop_564451(
    name: "integrationRuntimesStop", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/stop",
    validator: validate_IntegrationRuntimesStop_564452, base: "",
    url: url_IntegrationRuntimesStop_564453, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesSyncCredentials_564463 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesSyncCredentials_564465(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesSyncCredentials_564464(path: JsonNode;
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
  var valid_564466 = path.getOrDefault("integrationRuntimeName")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "integrationRuntimeName", valid_564466
  var valid_564467 = path.getOrDefault("subscriptionId")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "subscriptionId", valid_564467
  var valid_564468 = path.getOrDefault("resourceGroupName")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "resourceGroupName", valid_564468
  var valid_564469 = path.getOrDefault("factoryName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "factoryName", valid_564469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564470 = query.getOrDefault("api-version")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "api-version", valid_564470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564471: Call_IntegrationRuntimesSyncCredentials_564463;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Force the integration runtime to synchronize credentials across integration runtime nodes, and this will override the credentials across all worker nodes with those available on the dispatcher node. If you already have the latest credential backup file, you should manually import it (preferred) on any self-hosted integration runtime node than using this API directly.
  ## 
  let valid = call_564471.validator(path, query, header, formData, body)
  let scheme = call_564471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564471.url(scheme.get, call_564471.host, call_564471.base,
                         call_564471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564471, url, valid)

proc call*(call_564472: Call_IntegrationRuntimesSyncCredentials_564463;
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
  var path_564473 = newJObject()
  var query_564474 = newJObject()
  add(query_564474, "api-version", newJString(apiVersion))
  add(path_564473, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564473, "subscriptionId", newJString(subscriptionId))
  add(path_564473, "resourceGroupName", newJString(resourceGroupName))
  add(path_564473, "factoryName", newJString(factoryName))
  result = call_564472.call(path_564473, query_564474, nil, nil, nil)

var integrationRuntimesSyncCredentials* = Call_IntegrationRuntimesSyncCredentials_564463(
    name: "integrationRuntimesSyncCredentials", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/syncCredentials",
    validator: validate_IntegrationRuntimesSyncCredentials_564464, base: "",
    url: url_IntegrationRuntimesSyncCredentials_564465, schemes: {Scheme.Https})
type
  Call_IntegrationRuntimesUpgrade_564475 = ref object of OpenApiRestCall_563566
proc url_IntegrationRuntimesUpgrade_564477(protocol: Scheme; host: string;
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

proc validate_IntegrationRuntimesUpgrade_564476(path: JsonNode; query: JsonNode;
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
  var valid_564478 = path.getOrDefault("integrationRuntimeName")
  valid_564478 = validateParameter(valid_564478, JString, required = true,
                                 default = nil)
  if valid_564478 != nil:
    section.add "integrationRuntimeName", valid_564478
  var valid_564479 = path.getOrDefault("subscriptionId")
  valid_564479 = validateParameter(valid_564479, JString, required = true,
                                 default = nil)
  if valid_564479 != nil:
    section.add "subscriptionId", valid_564479
  var valid_564480 = path.getOrDefault("resourceGroupName")
  valid_564480 = validateParameter(valid_564480, JString, required = true,
                                 default = nil)
  if valid_564480 != nil:
    section.add "resourceGroupName", valid_564480
  var valid_564481 = path.getOrDefault("factoryName")
  valid_564481 = validateParameter(valid_564481, JString, required = true,
                                 default = nil)
  if valid_564481 != nil:
    section.add "factoryName", valid_564481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564482 = query.getOrDefault("api-version")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "api-version", valid_564482
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564483: Call_IntegrationRuntimesUpgrade_564475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Upgrade self-hosted integration runtime to latest version if availability.
  ## 
  let valid = call_564483.validator(path, query, header, formData, body)
  let scheme = call_564483.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564483.url(scheme.get, call_564483.host, call_564483.base,
                         call_564483.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564483, url, valid)

proc call*(call_564484: Call_IntegrationRuntimesUpgrade_564475; apiVersion: string;
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
  var path_564485 = newJObject()
  var query_564486 = newJObject()
  add(query_564486, "api-version", newJString(apiVersion))
  add(path_564485, "integrationRuntimeName", newJString(integrationRuntimeName))
  add(path_564485, "subscriptionId", newJString(subscriptionId))
  add(path_564485, "resourceGroupName", newJString(resourceGroupName))
  add(path_564485, "factoryName", newJString(factoryName))
  result = call_564484.call(path_564485, query_564486, nil, nil, nil)

var integrationRuntimesUpgrade* = Call_IntegrationRuntimesUpgrade_564475(
    name: "integrationRuntimesUpgrade", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/integrationRuntimes/{integrationRuntimeName}/upgrade",
    validator: validate_IntegrationRuntimesUpgrade_564476, base: "",
    url: url_IntegrationRuntimesUpgrade_564477, schemes: {Scheme.Https})
type
  Call_LinkedServicesListByFactory_564487 = ref object of OpenApiRestCall_563566
proc url_LinkedServicesListByFactory_564489(protocol: Scheme; host: string;
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

proc validate_LinkedServicesListByFactory_564488(path: JsonNode; query: JsonNode;
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
  var valid_564490 = path.getOrDefault("subscriptionId")
  valid_564490 = validateParameter(valid_564490, JString, required = true,
                                 default = nil)
  if valid_564490 != nil:
    section.add "subscriptionId", valid_564490
  var valid_564491 = path.getOrDefault("resourceGroupName")
  valid_564491 = validateParameter(valid_564491, JString, required = true,
                                 default = nil)
  if valid_564491 != nil:
    section.add "resourceGroupName", valid_564491
  var valid_564492 = path.getOrDefault("factoryName")
  valid_564492 = validateParameter(valid_564492, JString, required = true,
                                 default = nil)
  if valid_564492 != nil:
    section.add "factoryName", valid_564492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564493 = query.getOrDefault("api-version")
  valid_564493 = validateParameter(valid_564493, JString, required = true,
                                 default = nil)
  if valid_564493 != nil:
    section.add "api-version", valid_564493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564494: Call_LinkedServicesListByFactory_564487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists linked services.
  ## 
  let valid = call_564494.validator(path, query, header, formData, body)
  let scheme = call_564494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564494.url(scheme.get, call_564494.host, call_564494.base,
                         call_564494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564494, url, valid)

proc call*(call_564495: Call_LinkedServicesListByFactory_564487;
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
  var path_564496 = newJObject()
  var query_564497 = newJObject()
  add(query_564497, "api-version", newJString(apiVersion))
  add(path_564496, "subscriptionId", newJString(subscriptionId))
  add(path_564496, "resourceGroupName", newJString(resourceGroupName))
  add(path_564496, "factoryName", newJString(factoryName))
  result = call_564495.call(path_564496, query_564497, nil, nil, nil)

var linkedServicesListByFactory* = Call_LinkedServicesListByFactory_564487(
    name: "linkedServicesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices",
    validator: validate_LinkedServicesListByFactory_564488, base: "",
    url: url_LinkedServicesListByFactory_564489, schemes: {Scheme.Https})
type
  Call_LinkedServicesCreateOrUpdate_564510 = ref object of OpenApiRestCall_563566
proc url_LinkedServicesCreateOrUpdate_564512(protocol: Scheme; host: string;
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

proc validate_LinkedServicesCreateOrUpdate_564511(path: JsonNode; query: JsonNode;
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
  var valid_564513 = path.getOrDefault("subscriptionId")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "subscriptionId", valid_564513
  var valid_564514 = path.getOrDefault("resourceGroupName")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "resourceGroupName", valid_564514
  var valid_564515 = path.getOrDefault("factoryName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "factoryName", valid_564515
  var valid_564516 = path.getOrDefault("linkedServiceName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "linkedServiceName", valid_564516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564517 = query.getOrDefault("api-version")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "api-version", valid_564517
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the linkedService entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564518 = header.getOrDefault("If-Match")
  valid_564518 = validateParameter(valid_564518, JString, required = false,
                                 default = nil)
  if valid_564518 != nil:
    section.add "If-Match", valid_564518
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

proc call*(call_564520: Call_LinkedServicesCreateOrUpdate_564510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a linked service.
  ## 
  let valid = call_564520.validator(path, query, header, formData, body)
  let scheme = call_564520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564520.url(scheme.get, call_564520.host, call_564520.base,
                         call_564520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564520, url, valid)

proc call*(call_564521: Call_LinkedServicesCreateOrUpdate_564510;
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
  var path_564522 = newJObject()
  var query_564523 = newJObject()
  var body_564524 = newJObject()
  add(query_564523, "api-version", newJString(apiVersion))
  add(path_564522, "subscriptionId", newJString(subscriptionId))
  add(path_564522, "resourceGroupName", newJString(resourceGroupName))
  add(path_564522, "factoryName", newJString(factoryName))
  add(path_564522, "linkedServiceName", newJString(linkedServiceName))
  if linkedService != nil:
    body_564524 = linkedService
  result = call_564521.call(path_564522, query_564523, nil, nil, body_564524)

var linkedServicesCreateOrUpdate* = Call_LinkedServicesCreateOrUpdate_564510(
    name: "linkedServicesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesCreateOrUpdate_564511, base: "",
    url: url_LinkedServicesCreateOrUpdate_564512, schemes: {Scheme.Https})
type
  Call_LinkedServicesGet_564498 = ref object of OpenApiRestCall_563566
proc url_LinkedServicesGet_564500(protocol: Scheme; host: string; base: string;
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

proc validate_LinkedServicesGet_564499(path: JsonNode; query: JsonNode;
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
  var valid_564501 = path.getOrDefault("subscriptionId")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "subscriptionId", valid_564501
  var valid_564502 = path.getOrDefault("resourceGroupName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "resourceGroupName", valid_564502
  var valid_564503 = path.getOrDefault("factoryName")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "factoryName", valid_564503
  var valid_564504 = path.getOrDefault("linkedServiceName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "linkedServiceName", valid_564504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564505 = query.getOrDefault("api-version")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = nil)
  if valid_564505 != nil:
    section.add "api-version", valid_564505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564506: Call_LinkedServicesGet_564498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a linked service.
  ## 
  let valid = call_564506.validator(path, query, header, formData, body)
  let scheme = call_564506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564506.url(scheme.get, call_564506.host, call_564506.base,
                         call_564506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564506, url, valid)

proc call*(call_564507: Call_LinkedServicesGet_564498; apiVersion: string;
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
  var path_564508 = newJObject()
  var query_564509 = newJObject()
  add(query_564509, "api-version", newJString(apiVersion))
  add(path_564508, "subscriptionId", newJString(subscriptionId))
  add(path_564508, "resourceGroupName", newJString(resourceGroupName))
  add(path_564508, "factoryName", newJString(factoryName))
  add(path_564508, "linkedServiceName", newJString(linkedServiceName))
  result = call_564507.call(path_564508, query_564509, nil, nil, nil)

var linkedServicesGet* = Call_LinkedServicesGet_564498(name: "linkedServicesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesGet_564499, base: "",
    url: url_LinkedServicesGet_564500, schemes: {Scheme.Https})
type
  Call_LinkedServicesDelete_564525 = ref object of OpenApiRestCall_563566
proc url_LinkedServicesDelete_564527(protocol: Scheme; host: string; base: string;
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

proc validate_LinkedServicesDelete_564526(path: JsonNode; query: JsonNode;
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
  var valid_564528 = path.getOrDefault("subscriptionId")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "subscriptionId", valid_564528
  var valid_564529 = path.getOrDefault("resourceGroupName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "resourceGroupName", valid_564529
  var valid_564530 = path.getOrDefault("factoryName")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "factoryName", valid_564530
  var valid_564531 = path.getOrDefault("linkedServiceName")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "linkedServiceName", valid_564531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564532 = query.getOrDefault("api-version")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "api-version", valid_564532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564533: Call_LinkedServicesDelete_564525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a linked service.
  ## 
  let valid = call_564533.validator(path, query, header, formData, body)
  let scheme = call_564533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564533.url(scheme.get, call_564533.host, call_564533.base,
                         call_564533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564533, url, valid)

proc call*(call_564534: Call_LinkedServicesDelete_564525; apiVersion: string;
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
  var path_564535 = newJObject()
  var query_564536 = newJObject()
  add(query_564536, "api-version", newJString(apiVersion))
  add(path_564535, "subscriptionId", newJString(subscriptionId))
  add(path_564535, "resourceGroupName", newJString(resourceGroupName))
  add(path_564535, "factoryName", newJString(factoryName))
  add(path_564535, "linkedServiceName", newJString(linkedServiceName))
  result = call_564534.call(path_564535, query_564536, nil, nil, nil)

var linkedServicesDelete* = Call_LinkedServicesDelete_564525(
    name: "linkedServicesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/linkedservices/{linkedServiceName}",
    validator: validate_LinkedServicesDelete_564526, base: "",
    url: url_LinkedServicesDelete_564527, schemes: {Scheme.Https})
type
  Call_PipelineRunsQueryByFactory_564537 = ref object of OpenApiRestCall_563566
proc url_PipelineRunsQueryByFactory_564539(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/pipelineruns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PipelineRunsQueryByFactory_564538(path: JsonNode; query: JsonNode;
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
  var valid_564540 = path.getOrDefault("subscriptionId")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "subscriptionId", valid_564540
  var valid_564541 = path.getOrDefault("resourceGroupName")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "resourceGroupName", valid_564541
  var valid_564542 = path.getOrDefault("factoryName")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "factoryName", valid_564542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564543 = query.getOrDefault("api-version")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "api-version", valid_564543
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

proc call*(call_564545: Call_PipelineRunsQueryByFactory_564537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query pipeline runs in the factory based on input filter conditions.
  ## 
  let valid = call_564545.validator(path, query, header, formData, body)
  let scheme = call_564545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564545.url(scheme.get, call_564545.host, call_564545.base,
                         call_564545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564545, url, valid)

proc call*(call_564546: Call_PipelineRunsQueryByFactory_564537; apiVersion: string;
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
  var path_564547 = newJObject()
  var query_564548 = newJObject()
  var body_564549 = newJObject()
  add(query_564548, "api-version", newJString(apiVersion))
  if filterParameters != nil:
    body_564549 = filterParameters
  add(path_564547, "subscriptionId", newJString(subscriptionId))
  add(path_564547, "resourceGroupName", newJString(resourceGroupName))
  add(path_564547, "factoryName", newJString(factoryName))
  result = call_564546.call(path_564547, query_564548, nil, nil, body_564549)

var pipelineRunsQueryByFactory* = Call_PipelineRunsQueryByFactory_564537(
    name: "pipelineRunsQueryByFactory", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns",
    validator: validate_PipelineRunsQueryByFactory_564538, base: "",
    url: url_PipelineRunsQueryByFactory_564539, schemes: {Scheme.Https})
type
  Call_PipelineRunsGet_564550 = ref object of OpenApiRestCall_563566
proc url_PipelineRunsGet_564552(protocol: Scheme; host: string; base: string;
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

proc validate_PipelineRunsGet_564551(path: JsonNode; query: JsonNode;
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
  var valid_564553 = path.getOrDefault("runId")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "runId", valid_564553
  var valid_564554 = path.getOrDefault("subscriptionId")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "subscriptionId", valid_564554
  var valid_564555 = path.getOrDefault("resourceGroupName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "resourceGroupName", valid_564555
  var valid_564556 = path.getOrDefault("factoryName")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "factoryName", valid_564556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564557 = query.getOrDefault("api-version")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "api-version", valid_564557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564558: Call_PipelineRunsGet_564550; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a pipeline run by its run ID.
  ## 
  let valid = call_564558.validator(path, query, header, formData, body)
  let scheme = call_564558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564558.url(scheme.get, call_564558.host, call_564558.base,
                         call_564558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564558, url, valid)

proc call*(call_564559: Call_PipelineRunsGet_564550; runId: string;
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
  var path_564560 = newJObject()
  var query_564561 = newJObject()
  add(path_564560, "runId", newJString(runId))
  add(query_564561, "api-version", newJString(apiVersion))
  add(path_564560, "subscriptionId", newJString(subscriptionId))
  add(path_564560, "resourceGroupName", newJString(resourceGroupName))
  add(path_564560, "factoryName", newJString(factoryName))
  result = call_564559.call(path_564560, query_564561, nil, nil, nil)

var pipelineRunsGet* = Call_PipelineRunsGet_564550(name: "pipelineRunsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}",
    validator: validate_PipelineRunsGet_564551, base: "", url: url_PipelineRunsGet_564552,
    schemes: {Scheme.Https})
type
  Call_ActivityRunsListByPipelineRun_564562 = ref object of OpenApiRestCall_563566
proc url_ActivityRunsListByPipelineRun_564564(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/activityruns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActivityRunsListByPipelineRun_564563(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List activity runs based on input filter conditions.
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
  var valid_564565 = path.getOrDefault("runId")
  valid_564565 = validateParameter(valid_564565, JString, required = true,
                                 default = nil)
  if valid_564565 != nil:
    section.add "runId", valid_564565
  var valid_564566 = path.getOrDefault("subscriptionId")
  valid_564566 = validateParameter(valid_564566, JString, required = true,
                                 default = nil)
  if valid_564566 != nil:
    section.add "subscriptionId", valid_564566
  var valid_564567 = path.getOrDefault("resourceGroupName")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "resourceGroupName", valid_564567
  var valid_564568 = path.getOrDefault("factoryName")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "factoryName", valid_564568
  result.add "path", section
  ## parameters in `query` object:
  ##   activityName: JString
  ##               : The name of the activity.
  ##   linkedServiceName: JString
  ##                    : The linked service name.
  ##   api-version: JString (required)
  ##              : The API version.
  ##   startTime: JString (required)
  ##            : The start time of activity runs in ISO8601 format.
  ##   status: JString
  ##         : The status of the pipeline run.
  ##   endTime: JString (required)
  ##          : The end time of activity runs in ISO8601 format.
  section = newJObject()
  var valid_564569 = query.getOrDefault("activityName")
  valid_564569 = validateParameter(valid_564569, JString, required = false,
                                 default = nil)
  if valid_564569 != nil:
    section.add "activityName", valid_564569
  var valid_564570 = query.getOrDefault("linkedServiceName")
  valid_564570 = validateParameter(valid_564570, JString, required = false,
                                 default = nil)
  if valid_564570 != nil:
    section.add "linkedServiceName", valid_564570
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564571 = query.getOrDefault("api-version")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "api-version", valid_564571
  var valid_564572 = query.getOrDefault("startTime")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "startTime", valid_564572
  var valid_564573 = query.getOrDefault("status")
  valid_564573 = validateParameter(valid_564573, JString, required = false,
                                 default = nil)
  if valid_564573 != nil:
    section.add "status", valid_564573
  var valid_564574 = query.getOrDefault("endTime")
  valid_564574 = validateParameter(valid_564574, JString, required = true,
                                 default = nil)
  if valid_564574 != nil:
    section.add "endTime", valid_564574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564575: Call_ActivityRunsListByPipelineRun_564562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List activity runs based on input filter conditions.
  ## 
  let valid = call_564575.validator(path, query, header, formData, body)
  let scheme = call_564575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564575.url(scheme.get, call_564575.host, call_564575.base,
                         call_564575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564575, url, valid)

proc call*(call_564576: Call_ActivityRunsListByPipelineRun_564562; runId: string;
          apiVersion: string; startTime: string; subscriptionId: string;
          resourceGroupName: string; factoryName: string; endTime: string;
          activityName: string = ""; linkedServiceName: string = ""; status: string = ""): Recallable =
  ## activityRunsListByPipelineRun
  ## List activity runs based on input filter conditions.
  ##   runId: string (required)
  ##        : The pipeline run identifier.
  ##   activityName: string
  ##               : The name of the activity.
  ##   linkedServiceName: string
  ##                    : The linked service name.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   startTime: string (required)
  ##            : The start time of activity runs in ISO8601 format.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   status: string
  ##         : The status of the pipeline run.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   endTime: string (required)
  ##          : The end time of activity runs in ISO8601 format.
  var path_564577 = newJObject()
  var query_564578 = newJObject()
  add(path_564577, "runId", newJString(runId))
  add(query_564578, "activityName", newJString(activityName))
  add(query_564578, "linkedServiceName", newJString(linkedServiceName))
  add(query_564578, "api-version", newJString(apiVersion))
  add(query_564578, "startTime", newJString(startTime))
  add(path_564577, "subscriptionId", newJString(subscriptionId))
  add(path_564577, "resourceGroupName", newJString(resourceGroupName))
  add(query_564578, "status", newJString(status))
  add(path_564577, "factoryName", newJString(factoryName))
  add(query_564578, "endTime", newJString(endTime))
  result = call_564576.call(path_564577, query_564578, nil, nil, nil)

var activityRunsListByPipelineRun* = Call_ActivityRunsListByPipelineRun_564562(
    name: "activityRunsListByPipelineRun", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelineruns/{runId}/activityruns",
    validator: validate_ActivityRunsListByPipelineRun_564563, base: "",
    url: url_ActivityRunsListByPipelineRun_564564, schemes: {Scheme.Https})
type
  Call_PipelinesListByFactory_564579 = ref object of OpenApiRestCall_563566
proc url_PipelinesListByFactory_564581(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesListByFactory_564580(path: JsonNode; query: JsonNode;
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
  var valid_564582 = path.getOrDefault("subscriptionId")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "subscriptionId", valid_564582
  var valid_564583 = path.getOrDefault("resourceGroupName")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "resourceGroupName", valid_564583
  var valid_564584 = path.getOrDefault("factoryName")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "factoryName", valid_564584
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564585 = query.getOrDefault("api-version")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "api-version", valid_564585
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564586: Call_PipelinesListByFactory_564579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  let valid = call_564586.validator(path, query, header, formData, body)
  let scheme = call_564586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564586.url(scheme.get, call_564586.host, call_564586.base,
                         call_564586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564586, url, valid)

proc call*(call_564587: Call_PipelinesListByFactory_564579; apiVersion: string;
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
  var path_564588 = newJObject()
  var query_564589 = newJObject()
  add(query_564589, "api-version", newJString(apiVersion))
  add(path_564588, "subscriptionId", newJString(subscriptionId))
  add(path_564588, "resourceGroupName", newJString(resourceGroupName))
  add(path_564588, "factoryName", newJString(factoryName))
  result = call_564587.call(path_564588, query_564589, nil, nil, nil)

var pipelinesListByFactory* = Call_PipelinesListByFactory_564579(
    name: "pipelinesListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines",
    validator: validate_PipelinesListByFactory_564580, base: "",
    url: url_PipelinesListByFactory_564581, schemes: {Scheme.Https})
type
  Call_PipelinesCreateOrUpdate_564602 = ref object of OpenApiRestCall_563566
proc url_PipelinesCreateOrUpdate_564604(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesCreateOrUpdate_564603(path: JsonNode; query: JsonNode;
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
  var valid_564605 = path.getOrDefault("subscriptionId")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "subscriptionId", valid_564605
  var valid_564606 = path.getOrDefault("pipelineName")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "pipelineName", valid_564606
  var valid_564607 = path.getOrDefault("resourceGroupName")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "resourceGroupName", valid_564607
  var valid_564608 = path.getOrDefault("factoryName")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "factoryName", valid_564608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564609 = query.getOrDefault("api-version")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "api-version", valid_564609
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the pipeline entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564610 = header.getOrDefault("If-Match")
  valid_564610 = validateParameter(valid_564610, JString, required = false,
                                 default = nil)
  if valid_564610 != nil:
    section.add "If-Match", valid_564610
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

proc call*(call_564612: Call_PipelinesCreateOrUpdate_564602; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a pipeline.
  ## 
  let valid = call_564612.validator(path, query, header, formData, body)
  let scheme = call_564612.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564612.url(scheme.get, call_564612.host, call_564612.base,
                         call_564612.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564612, url, valid)

proc call*(call_564613: Call_PipelinesCreateOrUpdate_564602; pipeline: JsonNode;
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
  var path_564614 = newJObject()
  var query_564615 = newJObject()
  var body_564616 = newJObject()
  if pipeline != nil:
    body_564616 = pipeline
  add(query_564615, "api-version", newJString(apiVersion))
  add(path_564614, "subscriptionId", newJString(subscriptionId))
  add(path_564614, "pipelineName", newJString(pipelineName))
  add(path_564614, "resourceGroupName", newJString(resourceGroupName))
  add(path_564614, "factoryName", newJString(factoryName))
  result = call_564613.call(path_564614, query_564615, nil, nil, body_564616)

var pipelinesCreateOrUpdate* = Call_PipelinesCreateOrUpdate_564602(
    name: "pipelinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesCreateOrUpdate_564603, base: "",
    url: url_PipelinesCreateOrUpdate_564604, schemes: {Scheme.Https})
type
  Call_PipelinesGet_564590 = ref object of OpenApiRestCall_563566
proc url_PipelinesGet_564592(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesGet_564591(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564593 = path.getOrDefault("subscriptionId")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "subscriptionId", valid_564593
  var valid_564594 = path.getOrDefault("pipelineName")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "pipelineName", valid_564594
  var valid_564595 = path.getOrDefault("resourceGroupName")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "resourceGroupName", valid_564595
  var valid_564596 = path.getOrDefault("factoryName")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "factoryName", valid_564596
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564597 = query.getOrDefault("api-version")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "api-version", valid_564597
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564598: Call_PipelinesGet_564590; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a pipeline.
  ## 
  let valid = call_564598.validator(path, query, header, formData, body)
  let scheme = call_564598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564598.url(scheme.get, call_564598.host, call_564598.base,
                         call_564598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564598, url, valid)

proc call*(call_564599: Call_PipelinesGet_564590; apiVersion: string;
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
  var path_564600 = newJObject()
  var query_564601 = newJObject()
  add(query_564601, "api-version", newJString(apiVersion))
  add(path_564600, "subscriptionId", newJString(subscriptionId))
  add(path_564600, "pipelineName", newJString(pipelineName))
  add(path_564600, "resourceGroupName", newJString(resourceGroupName))
  add(path_564600, "factoryName", newJString(factoryName))
  result = call_564599.call(path_564600, query_564601, nil, nil, nil)

var pipelinesGet* = Call_PipelinesGet_564590(name: "pipelinesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesGet_564591, base: "", url: url_PipelinesGet_564592,
    schemes: {Scheme.Https})
type
  Call_PipelinesDelete_564617 = ref object of OpenApiRestCall_563566
proc url_PipelinesDelete_564619(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesDelete_564618(path: JsonNode; query: JsonNode;
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
  var valid_564620 = path.getOrDefault("subscriptionId")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "subscriptionId", valid_564620
  var valid_564621 = path.getOrDefault("pipelineName")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "pipelineName", valid_564621
  var valid_564622 = path.getOrDefault("resourceGroupName")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "resourceGroupName", valid_564622
  var valid_564623 = path.getOrDefault("factoryName")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "factoryName", valid_564623
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564624 = query.getOrDefault("api-version")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "api-version", valid_564624
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564625: Call_PipelinesDelete_564617; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline.
  ## 
  let valid = call_564625.validator(path, query, header, formData, body)
  let scheme = call_564625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564625.url(scheme.get, call_564625.host, call_564625.base,
                         call_564625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564625, url, valid)

proc call*(call_564626: Call_PipelinesDelete_564617; apiVersion: string;
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
  var path_564627 = newJObject()
  var query_564628 = newJObject()
  add(query_564628, "api-version", newJString(apiVersion))
  add(path_564627, "subscriptionId", newJString(subscriptionId))
  add(path_564627, "pipelineName", newJString(pipelineName))
  add(path_564627, "resourceGroupName", newJString(resourceGroupName))
  add(path_564627, "factoryName", newJString(factoryName))
  result = call_564626.call(path_564627, query_564628, nil, nil, nil)

var pipelinesDelete* = Call_PipelinesDelete_564617(name: "pipelinesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}",
    validator: validate_PipelinesDelete_564618, base: "", url: url_PipelinesDelete_564619,
    schemes: {Scheme.Https})
type
  Call_PipelinesCreateRun_564629 = ref object of OpenApiRestCall_563566
proc url_PipelinesCreateRun_564631(protocol: Scheme; host: string; base: string;
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

proc validate_PipelinesCreateRun_564630(path: JsonNode; query: JsonNode;
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
  var valid_564632 = path.getOrDefault("subscriptionId")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "subscriptionId", valid_564632
  var valid_564633 = path.getOrDefault("pipelineName")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "pipelineName", valid_564633
  var valid_564634 = path.getOrDefault("resourceGroupName")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "resourceGroupName", valid_564634
  var valid_564635 = path.getOrDefault("factoryName")
  valid_564635 = validateParameter(valid_564635, JString, required = true,
                                 default = nil)
  if valid_564635 != nil:
    section.add "factoryName", valid_564635
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564636 = query.getOrDefault("api-version")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "api-version", valid_564636
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters of the pipeline run.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564638: Call_PipelinesCreateRun_564629; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a run of a pipeline.
  ## 
  let valid = call_564638.validator(path, query, header, formData, body)
  let scheme = call_564638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564638.url(scheme.get, call_564638.host, call_564638.base,
                         call_564638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564638, url, valid)

proc call*(call_564639: Call_PipelinesCreateRun_564629; apiVersion: string;
          subscriptionId: string; pipelineName: string; resourceGroupName: string;
          factoryName: string; parameters: JsonNode = nil): Recallable =
  ## pipelinesCreateRun
  ## Creates a run of a pipeline.
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
  ##   parameters: JObject
  ##             : Parameters of the pipeline run.
  var path_564640 = newJObject()
  var query_564641 = newJObject()
  var body_564642 = newJObject()
  add(query_564641, "api-version", newJString(apiVersion))
  add(path_564640, "subscriptionId", newJString(subscriptionId))
  add(path_564640, "pipelineName", newJString(pipelineName))
  add(path_564640, "resourceGroupName", newJString(resourceGroupName))
  add(path_564640, "factoryName", newJString(factoryName))
  if parameters != nil:
    body_564642 = parameters
  result = call_564639.call(path_564640, query_564641, nil, nil, body_564642)

var pipelinesCreateRun* = Call_PipelinesCreateRun_564629(
    name: "pipelinesCreateRun", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/{pipelineName}/createRun",
    validator: validate_PipelinesCreateRun_564630, base: "",
    url: url_PipelinesCreateRun_564631, schemes: {Scheme.Https})
type
  Call_TriggersListByFactory_564643 = ref object of OpenApiRestCall_563566
proc url_TriggersListByFactory_564645(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersListByFactory_564644(path: JsonNode; query: JsonNode;
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
  var valid_564646 = path.getOrDefault("subscriptionId")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "subscriptionId", valid_564646
  var valid_564647 = path.getOrDefault("resourceGroupName")
  valid_564647 = validateParameter(valid_564647, JString, required = true,
                                 default = nil)
  if valid_564647 != nil:
    section.add "resourceGroupName", valid_564647
  var valid_564648 = path.getOrDefault("factoryName")
  valid_564648 = validateParameter(valid_564648, JString, required = true,
                                 default = nil)
  if valid_564648 != nil:
    section.add "factoryName", valid_564648
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564649 = query.getOrDefault("api-version")
  valid_564649 = validateParameter(valid_564649, JString, required = true,
                                 default = nil)
  if valid_564649 != nil:
    section.add "api-version", valid_564649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564650: Call_TriggersListByFactory_564643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists triggers.
  ## 
  let valid = call_564650.validator(path, query, header, formData, body)
  let scheme = call_564650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564650.url(scheme.get, call_564650.host, call_564650.base,
                         call_564650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564650, url, valid)

proc call*(call_564651: Call_TriggersListByFactory_564643; apiVersion: string;
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
  var path_564652 = newJObject()
  var query_564653 = newJObject()
  add(query_564653, "api-version", newJString(apiVersion))
  add(path_564652, "subscriptionId", newJString(subscriptionId))
  add(path_564652, "resourceGroupName", newJString(resourceGroupName))
  add(path_564652, "factoryName", newJString(factoryName))
  result = call_564651.call(path_564652, query_564653, nil, nil, nil)

var triggersListByFactory* = Call_TriggersListByFactory_564643(
    name: "triggersListByFactory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers",
    validator: validate_TriggersListByFactory_564644, base: "",
    url: url_TriggersListByFactory_564645, schemes: {Scheme.Https})
type
  Call_TriggersCreateOrUpdate_564666 = ref object of OpenApiRestCall_563566
proc url_TriggersCreateOrUpdate_564668(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersCreateOrUpdate_564667(path: JsonNode; query: JsonNode;
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
  var valid_564669 = path.getOrDefault("subscriptionId")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "subscriptionId", valid_564669
  var valid_564670 = path.getOrDefault("resourceGroupName")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "resourceGroupName", valid_564670
  var valid_564671 = path.getOrDefault("triggerName")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "triggerName", valid_564671
  var valid_564672 = path.getOrDefault("factoryName")
  valid_564672 = validateParameter(valid_564672, JString, required = true,
                                 default = nil)
  if valid_564672 != nil:
    section.add "factoryName", valid_564672
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564673 = query.getOrDefault("api-version")
  valid_564673 = validateParameter(valid_564673, JString, required = true,
                                 default = nil)
  if valid_564673 != nil:
    section.add "api-version", valid_564673
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : ETag of the trigger entity.  Should only be specified for update, for which it should match existing entity or can be * for unconditional update.
  section = newJObject()
  var valid_564674 = header.getOrDefault("If-Match")
  valid_564674 = validateParameter(valid_564674, JString, required = false,
                                 default = nil)
  if valid_564674 != nil:
    section.add "If-Match", valid_564674
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

proc call*(call_564676: Call_TriggersCreateOrUpdate_564666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a trigger.
  ## 
  let valid = call_564676.validator(path, query, header, formData, body)
  let scheme = call_564676.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564676.url(scheme.get, call_564676.host, call_564676.base,
                         call_564676.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564676, url, valid)

proc call*(call_564677: Call_TriggersCreateOrUpdate_564666; apiVersion: string;
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
  var path_564678 = newJObject()
  var query_564679 = newJObject()
  var body_564680 = newJObject()
  add(query_564679, "api-version", newJString(apiVersion))
  add(path_564678, "subscriptionId", newJString(subscriptionId))
  add(path_564678, "resourceGroupName", newJString(resourceGroupName))
  add(path_564678, "triggerName", newJString(triggerName))
  add(path_564678, "factoryName", newJString(factoryName))
  if trigger != nil:
    body_564680 = trigger
  result = call_564677.call(path_564678, query_564679, nil, nil, body_564680)

var triggersCreateOrUpdate* = Call_TriggersCreateOrUpdate_564666(
    name: "triggersCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersCreateOrUpdate_564667, base: "",
    url: url_TriggersCreateOrUpdate_564668, schemes: {Scheme.Https})
type
  Call_TriggersGet_564654 = ref object of OpenApiRestCall_563566
proc url_TriggersGet_564656(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersGet_564655(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564657 = path.getOrDefault("subscriptionId")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "subscriptionId", valid_564657
  var valid_564658 = path.getOrDefault("resourceGroupName")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = nil)
  if valid_564658 != nil:
    section.add "resourceGroupName", valid_564658
  var valid_564659 = path.getOrDefault("triggerName")
  valid_564659 = validateParameter(valid_564659, JString, required = true,
                                 default = nil)
  if valid_564659 != nil:
    section.add "triggerName", valid_564659
  var valid_564660 = path.getOrDefault("factoryName")
  valid_564660 = validateParameter(valid_564660, JString, required = true,
                                 default = nil)
  if valid_564660 != nil:
    section.add "factoryName", valid_564660
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564661 = query.getOrDefault("api-version")
  valid_564661 = validateParameter(valid_564661, JString, required = true,
                                 default = nil)
  if valid_564661 != nil:
    section.add "api-version", valid_564661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564662: Call_TriggersGet_564654; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a trigger.
  ## 
  let valid = call_564662.validator(path, query, header, formData, body)
  let scheme = call_564662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564662.url(scheme.get, call_564662.host, call_564662.base,
                         call_564662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564662, url, valid)

proc call*(call_564663: Call_TriggersGet_564654; apiVersion: string;
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
  var path_564664 = newJObject()
  var query_564665 = newJObject()
  add(query_564665, "api-version", newJString(apiVersion))
  add(path_564664, "subscriptionId", newJString(subscriptionId))
  add(path_564664, "resourceGroupName", newJString(resourceGroupName))
  add(path_564664, "triggerName", newJString(triggerName))
  add(path_564664, "factoryName", newJString(factoryName))
  result = call_564663.call(path_564664, query_564665, nil, nil, nil)

var triggersGet* = Call_TriggersGet_564654(name: "triggersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
                                        validator: validate_TriggersGet_564655,
                                        base: "", url: url_TriggersGet_564656,
                                        schemes: {Scheme.Https})
type
  Call_TriggersDelete_564681 = ref object of OpenApiRestCall_563566
proc url_TriggersDelete_564683(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersDelete_564682(path: JsonNode; query: JsonNode;
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
  var valid_564684 = path.getOrDefault("subscriptionId")
  valid_564684 = validateParameter(valid_564684, JString, required = true,
                                 default = nil)
  if valid_564684 != nil:
    section.add "subscriptionId", valid_564684
  var valid_564685 = path.getOrDefault("resourceGroupName")
  valid_564685 = validateParameter(valid_564685, JString, required = true,
                                 default = nil)
  if valid_564685 != nil:
    section.add "resourceGroupName", valid_564685
  var valid_564686 = path.getOrDefault("triggerName")
  valid_564686 = validateParameter(valid_564686, JString, required = true,
                                 default = nil)
  if valid_564686 != nil:
    section.add "triggerName", valid_564686
  var valid_564687 = path.getOrDefault("factoryName")
  valid_564687 = validateParameter(valid_564687, JString, required = true,
                                 default = nil)
  if valid_564687 != nil:
    section.add "factoryName", valid_564687
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564688 = query.getOrDefault("api-version")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = nil)
  if valid_564688 != nil:
    section.add "api-version", valid_564688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564689: Call_TriggersDelete_564681; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a trigger.
  ## 
  let valid = call_564689.validator(path, query, header, formData, body)
  let scheme = call_564689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564689.url(scheme.get, call_564689.host, call_564689.base,
                         call_564689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564689, url, valid)

proc call*(call_564690: Call_TriggersDelete_564681; apiVersion: string;
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
  var path_564691 = newJObject()
  var query_564692 = newJObject()
  add(query_564692, "api-version", newJString(apiVersion))
  add(path_564691, "subscriptionId", newJString(subscriptionId))
  add(path_564691, "resourceGroupName", newJString(resourceGroupName))
  add(path_564691, "triggerName", newJString(triggerName))
  add(path_564691, "factoryName", newJString(factoryName))
  result = call_564690.call(path_564691, query_564692, nil, nil, nil)

var triggersDelete* = Call_TriggersDelete_564681(name: "triggersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}",
    validator: validate_TriggersDelete_564682, base: "", url: url_TriggersDelete_564683,
    schemes: {Scheme.Https})
type
  Call_TriggersStart_564693 = ref object of OpenApiRestCall_563566
proc url_TriggersStart_564695(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersStart_564694(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564696 = path.getOrDefault("subscriptionId")
  valid_564696 = validateParameter(valid_564696, JString, required = true,
                                 default = nil)
  if valid_564696 != nil:
    section.add "subscriptionId", valid_564696
  var valid_564697 = path.getOrDefault("resourceGroupName")
  valid_564697 = validateParameter(valid_564697, JString, required = true,
                                 default = nil)
  if valid_564697 != nil:
    section.add "resourceGroupName", valid_564697
  var valid_564698 = path.getOrDefault("triggerName")
  valid_564698 = validateParameter(valid_564698, JString, required = true,
                                 default = nil)
  if valid_564698 != nil:
    section.add "triggerName", valid_564698
  var valid_564699 = path.getOrDefault("factoryName")
  valid_564699 = validateParameter(valid_564699, JString, required = true,
                                 default = nil)
  if valid_564699 != nil:
    section.add "factoryName", valid_564699
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564700 = query.getOrDefault("api-version")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "api-version", valid_564700
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564701: Call_TriggersStart_564693; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a trigger.
  ## 
  let valid = call_564701.validator(path, query, header, formData, body)
  let scheme = call_564701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564701.url(scheme.get, call_564701.host, call_564701.base,
                         call_564701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564701, url, valid)

proc call*(call_564702: Call_TriggersStart_564693; apiVersion: string;
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
  var path_564703 = newJObject()
  var query_564704 = newJObject()
  add(query_564704, "api-version", newJString(apiVersion))
  add(path_564703, "subscriptionId", newJString(subscriptionId))
  add(path_564703, "resourceGroupName", newJString(resourceGroupName))
  add(path_564703, "triggerName", newJString(triggerName))
  add(path_564703, "factoryName", newJString(factoryName))
  result = call_564702.call(path_564703, query_564704, nil, nil, nil)

var triggersStart* = Call_TriggersStart_564693(name: "triggersStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/start",
    validator: validate_TriggersStart_564694, base: "", url: url_TriggersStart_564695,
    schemes: {Scheme.Https})
type
  Call_TriggersStop_564705 = ref object of OpenApiRestCall_563566
proc url_TriggersStop_564707(protocol: Scheme; host: string; base: string;
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

proc validate_TriggersStop_564706(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564708 = path.getOrDefault("subscriptionId")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = nil)
  if valid_564708 != nil:
    section.add "subscriptionId", valid_564708
  var valid_564709 = path.getOrDefault("resourceGroupName")
  valid_564709 = validateParameter(valid_564709, JString, required = true,
                                 default = nil)
  if valid_564709 != nil:
    section.add "resourceGroupName", valid_564709
  var valid_564710 = path.getOrDefault("triggerName")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "triggerName", valid_564710
  var valid_564711 = path.getOrDefault("factoryName")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "factoryName", valid_564711
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564712 = query.getOrDefault("api-version")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "api-version", valid_564712
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564713: Call_TriggersStop_564705; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a trigger.
  ## 
  let valid = call_564713.validator(path, query, header, formData, body)
  let scheme = call_564713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564713.url(scheme.get, call_564713.host, call_564713.base,
                         call_564713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564713, url, valid)

proc call*(call_564714: Call_TriggersStop_564705; apiVersion: string;
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
  var path_564715 = newJObject()
  var query_564716 = newJObject()
  add(query_564716, "api-version", newJString(apiVersion))
  add(path_564715, "subscriptionId", newJString(subscriptionId))
  add(path_564715, "resourceGroupName", newJString(resourceGroupName))
  add(path_564715, "triggerName", newJString(triggerName))
  add(path_564715, "factoryName", newJString(factoryName))
  result = call_564714.call(path_564715, query_564716, nil, nil, nil)

var triggersStop* = Call_TriggersStop_564705(name: "triggersStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/stop",
    validator: validate_TriggersStop_564706, base: "", url: url_TriggersStop_564707,
    schemes: {Scheme.Https})
type
  Call_TriggersListRuns_564717 = ref object of OpenApiRestCall_563566
proc url_TriggersListRuns_564719(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/triggerruns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TriggersListRuns_564718(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## List trigger runs.
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
  var valid_564720 = path.getOrDefault("subscriptionId")
  valid_564720 = validateParameter(valid_564720, JString, required = true,
                                 default = nil)
  if valid_564720 != nil:
    section.add "subscriptionId", valid_564720
  var valid_564721 = path.getOrDefault("resourceGroupName")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = nil)
  if valid_564721 != nil:
    section.add "resourceGroupName", valid_564721
  var valid_564722 = path.getOrDefault("triggerName")
  valid_564722 = validateParameter(valid_564722, JString, required = true,
                                 default = nil)
  if valid_564722 != nil:
    section.add "triggerName", valid_564722
  var valid_564723 = path.getOrDefault("factoryName")
  valid_564723 = validateParameter(valid_564723, JString, required = true,
                                 default = nil)
  if valid_564723 != nil:
    section.add "factoryName", valid_564723
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version.
  ##   startTime: JString (required)
  ##            : Start time for trigger runs.
  ##   endTime: JString (required)
  ##          : End time for trigger runs.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564724 = query.getOrDefault("api-version")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "api-version", valid_564724
  var valid_564725 = query.getOrDefault("startTime")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "startTime", valid_564725
  var valid_564726 = query.getOrDefault("endTime")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "endTime", valid_564726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564727: Call_TriggersListRuns_564717; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List trigger runs.
  ## 
  let valid = call_564727.validator(path, query, header, formData, body)
  let scheme = call_564727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564727.url(scheme.get, call_564727.host, call_564727.base,
                         call_564727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564727, url, valid)

proc call*(call_564728: Call_TriggersListRuns_564717; apiVersion: string;
          startTime: string; subscriptionId: string; resourceGroupName: string;
          triggerName: string; factoryName: string; endTime: string): Recallable =
  ## triggersListRuns
  ## List trigger runs.
  ##   apiVersion: string (required)
  ##             : The API version.
  ##   startTime: string (required)
  ##            : Start time for trigger runs.
  ##   subscriptionId: string (required)
  ##                 : The subscription identifier.
  ##   resourceGroupName: string (required)
  ##                    : The resource group name.
  ##   triggerName: string (required)
  ##              : The trigger name.
  ##   factoryName: string (required)
  ##              : The factory name.
  ##   endTime: string (required)
  ##          : End time for trigger runs.
  var path_564729 = newJObject()
  var query_564730 = newJObject()
  add(query_564730, "api-version", newJString(apiVersion))
  add(query_564730, "startTime", newJString(startTime))
  add(path_564729, "subscriptionId", newJString(subscriptionId))
  add(path_564729, "resourceGroupName", newJString(resourceGroupName))
  add(path_564729, "triggerName", newJString(triggerName))
  add(path_564729, "factoryName", newJString(factoryName))
  add(query_564730, "endTime", newJString(endTime))
  result = call_564728.call(path_564729, query_564730, nil, nil, nil)

var triggersListRuns* = Call_TriggersListRuns_564717(name: "triggersListRuns",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/triggers/{triggerName}/triggerruns",
    validator: validate_TriggersListRuns_564718, base: "",
    url: url_TriggersListRuns_564719, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
