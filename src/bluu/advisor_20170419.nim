
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: AdvisorManagementClient
## version: 2017-04-19
## termsOfService: (not provided)
## license: (not provided)
## 
## REST APIs for Azure Advisor
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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
  macServiceName = "advisor"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RecommendationMetadataList_563778 = ref object of OpenApiRestCall_563556
proc url_RecommendationMetadataList_563780(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecommendationMetadataList_563779(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563964: Call_RecommendationMetadataList_563778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_563964.validator(path, query, header, formData, body)
  let scheme = call_563964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563964.url(scheme.get, call_563964.host, call_563964.base,
                         call_563964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563964, url, valid)

proc call*(call_564035: Call_RecommendationMetadataList_563778; apiVersion: string): Recallable =
  ## recommendationMetadataList
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_564036 = newJObject()
  add(query_564036, "api-version", newJString(apiVersion))
  result = call_564035.call(nil, query_564036, nil, nil, nil)

var recommendationMetadataList* = Call_RecommendationMetadataList_563778(
    name: "recommendationMetadataList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Advisor/metadata",
    validator: validate_RecommendationMetadataList_563779, base: "",
    url: url_RecommendationMetadataList_563780, schemes: {Scheme.Https})
type
  Call_RecommendationMetadataGet_564076 = ref object of OpenApiRestCall_563556
proc url_RecommendationMetadataGet_564078(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.Advisor/metadata/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationMetadataGet_564077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of metadata entity.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564093 = path.getOrDefault("name")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "name", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564095: Call_RecommendationMetadataGet_564076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_564095.validator(path, query, header, formData, body)
  let scheme = call_564095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564095.url(scheme.get, call_564095.host, call_564095.base,
                         call_564095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564095, url, valid)

proc call*(call_564096: Call_RecommendationMetadataGet_564076; apiVersion: string;
          name: string): Recallable =
  ## recommendationMetadataGet
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : Name of metadata entity.
  var path_564097 = newJObject()
  var query_564098 = newJObject()
  add(query_564098, "api-version", newJString(apiVersion))
  add(path_564097, "name", newJString(name))
  result = call_564096.call(path_564097, query_564098, nil, nil, nil)

var recommendationMetadataGet* = Call_RecommendationMetadataGet_564076(
    name: "recommendationMetadataGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Advisor/metadata/{name}",
    validator: validate_RecommendationMetadataGet_564077, base: "",
    url: url_RecommendationMetadataGet_564078, schemes: {Scheme.Https})
type
  Call_OperationsList_564099 = ref object of OpenApiRestCall_563556
proc url_OperationsList_564101(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_564100(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available Advisor REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564103: Call_OperationsList_564099; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available Advisor REST API operations.
  ## 
  let valid = call_564103.validator(path, query, header, formData, body)
  let scheme = call_564103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564103.url(scheme.get, call_564103.host, call_564103.base,
                         call_564103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564103, url, valid)

proc call*(call_564104: Call_OperationsList_564099; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the available Advisor REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_564105 = newJObject()
  add(query_564105, "api-version", newJString(apiVersion))
  result = call_564104.call(nil, query_564105, nil, nil, nil)

var operationsList* = Call_OperationsList_564099(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Advisor/operations",
    validator: validate_OperationsList_564100, base: "", url: url_OperationsList_564101,
    schemes: {Scheme.Https})
type
  Call_ConfigurationsCreateInSubscription_564115 = ref object of OpenApiRestCall_563556
proc url_ConfigurationsCreateInSubscription_564117(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsCreateInSubscription_564116(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create/Overwrite Azure Advisor configuration and also delete all configurations of contained resource groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564118 = path.getOrDefault("subscriptionId")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "subscriptionId", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   configContract: JObject (required)
  ##                 : The Azure Advisor configuration data structure.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_ConfigurationsCreateInSubscription_564115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create/Overwrite Azure Advisor configuration and also delete all configurations of contained resource groups.
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_ConfigurationsCreateInSubscription_564115;
          apiVersion: string; subscriptionId: string; configContract: JsonNode): Recallable =
  ## configurationsCreateInSubscription
  ## Create/Overwrite Azure Advisor configuration and also delete all configurations of contained resource groups.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   configContract: JObject (required)
  ##                 : The Azure Advisor configuration data structure.
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  var body_564125 = newJObject()
  add(query_564124, "api-version", newJString(apiVersion))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  if configContract != nil:
    body_564125 = configContract
  result = call_564122.call(path_564123, query_564124, nil, nil, body_564125)

var configurationsCreateInSubscription* = Call_ConfigurationsCreateInSubscription_564115(
    name: "configurationsCreateInSubscription", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/configurations",
    validator: validate_ConfigurationsCreateInSubscription_564116, base: "",
    url: url_ConfigurationsCreateInSubscription_564117, schemes: {Scheme.Https})
type
  Call_ConfigurationsListBySubscription_564106 = ref object of OpenApiRestCall_563556
proc url_ConfigurationsListBySubscription_564108(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsListBySubscription_564107(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve Azure Advisor configurations and also retrieve configurations of contained resource groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564109 = path.getOrDefault("subscriptionId")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "subscriptionId", valid_564109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564110 = query.getOrDefault("api-version")
  valid_564110 = validateParameter(valid_564110, JString, required = true,
                                 default = nil)
  if valid_564110 != nil:
    section.add "api-version", valid_564110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564111: Call_ConfigurationsListBySubscription_564106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve Azure Advisor configurations and also retrieve configurations of contained resource groups.
  ## 
  let valid = call_564111.validator(path, query, header, formData, body)
  let scheme = call_564111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564111.url(scheme.get, call_564111.host, call_564111.base,
                         call_564111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564111, url, valid)

proc call*(call_564112: Call_ConfigurationsListBySubscription_564106;
          apiVersion: string; subscriptionId: string): Recallable =
  ## configurationsListBySubscription
  ## Retrieve Azure Advisor configurations and also retrieve configurations of contained resource groups.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_564113 = newJObject()
  var query_564114 = newJObject()
  add(query_564114, "api-version", newJString(apiVersion))
  add(path_564113, "subscriptionId", newJString(subscriptionId))
  result = call_564112.call(path_564113, query_564114, nil, nil, nil)

var configurationsListBySubscription* = Call_ConfigurationsListBySubscription_564106(
    name: "configurationsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/configurations",
    validator: validate_ConfigurationsListBySubscription_564107, base: "",
    url: url_ConfigurationsListBySubscription_564108, schemes: {Scheme.Https})
type
  Call_RecommendationsGenerate_564126 = ref object of OpenApiRestCall_563556
proc url_RecommendationsGenerate_564128(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/generateRecommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsGenerate_564127(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates the recommendation generation or computation process for a subscription. This operation is asynchronous. The generated recommendations are stored in a cache in the Advisor service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_RecommendationsGenerate_564126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the recommendation generation or computation process for a subscription. This operation is asynchronous. The generated recommendations are stored in a cache in the Advisor service.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_RecommendationsGenerate_564126; apiVersion: string;
          subscriptionId: string): Recallable =
  ## recommendationsGenerate
  ## Initiates the recommendation generation or computation process for a subscription. This operation is asynchronous. The generated recommendations are stored in a cache in the Advisor service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  add(query_564134, "api-version", newJString(apiVersion))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  result = call_564132.call(path_564133, query_564134, nil, nil, nil)

var recommendationsGenerate* = Call_RecommendationsGenerate_564126(
    name: "recommendationsGenerate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/generateRecommendations",
    validator: validate_RecommendationsGenerate_564127, base: "",
    url: url_RecommendationsGenerate_564128, schemes: {Scheme.Https})
type
  Call_RecommendationsGetGenerateStatus_564135 = ref object of OpenApiRestCall_563556
proc url_RecommendationsGetGenerateStatus_564137(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/generateRecommendations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsGetGenerateStatus_564136(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the status of the recommendation computation or generation process. Invoke this API after calling the generation recommendation. The URI of this API is returned in the Location field of the response header.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564138 = path.getOrDefault("operationId")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "operationId", valid_564138
  var valid_564139 = path.getOrDefault("subscriptionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "subscriptionId", valid_564139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564140 = query.getOrDefault("api-version")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "api-version", valid_564140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564141: Call_RecommendationsGetGenerateStatus_564135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the status of the recommendation computation or generation process. Invoke this API after calling the generation recommendation. The URI of this API is returned in the Location field of the response header.
  ## 
  let valid = call_564141.validator(path, query, header, formData, body)
  let scheme = call_564141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564141.url(scheme.get, call_564141.host, call_564141.base,
                         call_564141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564141, url, valid)

proc call*(call_564142: Call_RecommendationsGetGenerateStatus_564135;
          apiVersion: string; operationId: string; subscriptionId: string): Recallable =
  ## recommendationsGetGenerateStatus
  ## Retrieves the status of the recommendation computation or generation process. Invoke this API after calling the generation recommendation. The URI of this API is returned in the Location field of the response header.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   operationId: string (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_564143 = newJObject()
  var query_564144 = newJObject()
  add(query_564144, "api-version", newJString(apiVersion))
  add(path_564143, "operationId", newJString(operationId))
  add(path_564143, "subscriptionId", newJString(subscriptionId))
  result = call_564142.call(path_564143, query_564144, nil, nil, nil)

var recommendationsGetGenerateStatus* = Call_RecommendationsGetGenerateStatus_564135(
    name: "recommendationsGetGenerateStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/generateRecommendations/{operationId}",
    validator: validate_RecommendationsGetGenerateStatus_564136, base: "",
    url: url_RecommendationsGetGenerateStatus_564137, schemes: {Scheme.Https})
type
  Call_RecommendationsList_564145 = ref object of OpenApiRestCall_563556
proc url_RecommendationsList_564147(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/recommendations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsList_564146(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Obtains cached recommendations for a subscription. The recommendations are generated or computed by invoking generateRecommendations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564149 = path.getOrDefault("subscriptionId")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "subscriptionId", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of recommendations per page if a paged version of this API is being used.
  ##   $filter: JString
  ##          : The filter to apply to the recommendations.
  section = newJObject()
  var valid_564150 = query.getOrDefault("$skipToken")
  valid_564150 = validateParameter(valid_564150, JString, required = false,
                                 default = nil)
  if valid_564150 != nil:
    section.add "$skipToken", valid_564150
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  var valid_564152 = query.getOrDefault("$top")
  valid_564152 = validateParameter(valid_564152, JInt, required = false, default = nil)
  if valid_564152 != nil:
    section.add "$top", valid_564152
  var valid_564153 = query.getOrDefault("$filter")
  valid_564153 = validateParameter(valid_564153, JString, required = false,
                                 default = nil)
  if valid_564153 != nil:
    section.add "$filter", valid_564153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_RecommendationsList_564145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains cached recommendations for a subscription. The recommendations are generated or computed by invoking generateRecommendations.
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_RecommendationsList_564145; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""; Top: int = 0;
          Filter: string = ""): Recallable =
  ## recommendationsList
  ## Obtains cached recommendations for a subscription. The recommendations are generated or computed by invoking generateRecommendations.
  ##   SkipToken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   Top: int
  ##      : The number of recommendations per page if a paged version of this API is being used.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Filter: string
  ##         : The filter to apply to the recommendations.
  var path_564156 = newJObject()
  var query_564157 = newJObject()
  add(query_564157, "$skipToken", newJString(SkipToken))
  add(query_564157, "api-version", newJString(apiVersion))
  add(query_564157, "$top", newJInt(Top))
  add(path_564156, "subscriptionId", newJString(subscriptionId))
  add(query_564157, "$filter", newJString(Filter))
  result = call_564155.call(path_564156, query_564157, nil, nil, nil)

var recommendationsList* = Call_RecommendationsList_564145(
    name: "recommendationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/recommendations",
    validator: validate_RecommendationsList_564146, base: "",
    url: url_RecommendationsList_564147, schemes: {Scheme.Https})
type
  Call_SuppressionsList_564158 = ref object of OpenApiRestCall_563556
proc url_SuppressionsList_564160(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Advisor/suppressions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SuppressionsList_564159(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves the list of snoozed or dismissed suppressions for a subscription. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564161 = path.getOrDefault("subscriptionId")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "subscriptionId", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of suppressions per page if a paged version of this API is being used.
  section = newJObject()
  var valid_564162 = query.getOrDefault("$skipToken")
  valid_564162 = validateParameter(valid_564162, JString, required = false,
                                 default = nil)
  if valid_564162 != nil:
    section.add "$skipToken", valid_564162
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564163 = query.getOrDefault("api-version")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "api-version", valid_564163
  var valid_564164 = query.getOrDefault("$top")
  valid_564164 = validateParameter(valid_564164, JInt, required = false, default = nil)
  if valid_564164 != nil:
    section.add "$top", valid_564164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564165: Call_SuppressionsList_564158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of snoozed or dismissed suppressions for a subscription. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  let valid = call_564165.validator(path, query, header, formData, body)
  let scheme = call_564165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564165.url(scheme.get, call_564165.host, call_564165.base,
                         call_564165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564165, url, valid)

proc call*(call_564166: Call_SuppressionsList_564158; apiVersion: string;
          subscriptionId: string; SkipToken: string = ""; Top: int = 0): Recallable =
  ## suppressionsList
  ## Retrieves the list of snoozed or dismissed suppressions for a subscription. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ##   SkipToken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   Top: int
  ##      : The number of suppressions per page if a paged version of this API is being used.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_564167 = newJObject()
  var query_564168 = newJObject()
  add(query_564168, "$skipToken", newJString(SkipToken))
  add(query_564168, "api-version", newJString(apiVersion))
  add(query_564168, "$top", newJInt(Top))
  add(path_564167, "subscriptionId", newJString(subscriptionId))
  result = call_564166.call(path_564167, query_564168, nil, nil, nil)

var suppressionsList* = Call_SuppressionsList_564158(name: "suppressionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/suppressions",
    validator: validate_SuppressionsList_564159, base: "",
    url: url_SuppressionsList_564160, schemes: {Scheme.Https})
type
  Call_ConfigurationsCreateInResourceGroup_564179 = ref object of OpenApiRestCall_563556
proc url_ConfigurationsCreateInResourceGroup_564181(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsCreateInResourceGroup_564180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroup: JString (required)
  ##                : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroup` field"
  var valid_564182 = path.getOrDefault("resourceGroup")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceGroup", valid_564182
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564184 = query.getOrDefault("api-version")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "api-version", valid_564184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   configContract: JObject (required)
  ##                 : The Azure Advisor configuration data structure.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_ConfigurationsCreateInResourceGroup_564179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_ConfigurationsCreateInResourceGroup_564179;
          resourceGroup: string; apiVersion: string; subscriptionId: string;
          configContract: JsonNode): Recallable =
  ## configurationsCreateInResourceGroup
  ##   resourceGroup: string (required)
  ##                : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   configContract: JObject (required)
  ##                 : The Azure Advisor configuration data structure.
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  var body_564190 = newJObject()
  add(path_564188, "resourceGroup", newJString(resourceGroup))
  add(query_564189, "api-version", newJString(apiVersion))
  add(path_564188, "subscriptionId", newJString(subscriptionId))
  if configContract != nil:
    body_564190 = configContract
  result = call_564187.call(path_564188, query_564189, nil, nil, body_564190)

var configurationsCreateInResourceGroup* = Call_ConfigurationsCreateInResourceGroup_564179(
    name: "configurationsCreateInResourceGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Advisor/configurations",
    validator: validate_ConfigurationsCreateInResourceGroup_564180, base: "",
    url: url_ConfigurationsCreateInResourceGroup_564181, schemes: {Scheme.Https})
type
  Call_ConfigurationsListByResourceGroup_564169 = ref object of OpenApiRestCall_563556
proc url_ConfigurationsListByResourceGroup_564171(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroup" in path, "`resourceGroup` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroup"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/configurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ConfigurationsListByResourceGroup_564170(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroup: JString (required)
  ##                : The name of the Azure resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroup` field"
  var valid_564172 = path.getOrDefault("resourceGroup")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "resourceGroup", valid_564172
  var valid_564173 = path.getOrDefault("subscriptionId")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "subscriptionId", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_ConfigurationsListByResourceGroup_564169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_ConfigurationsListByResourceGroup_564169;
          resourceGroup: string; apiVersion: string; subscriptionId: string): Recallable =
  ## configurationsListByResourceGroup
  ##   resourceGroup: string (required)
  ##                : The name of the Azure resource group.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  add(path_564177, "resourceGroup", newJString(resourceGroup))
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  result = call_564176.call(path_564177, query_564178, nil, nil, nil)

var configurationsListByResourceGroup* = Call_ConfigurationsListByResourceGroup_564169(
    name: "configurationsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Advisor/configurations",
    validator: validate_ConfigurationsListByResourceGroup_564170, base: "",
    url: url_ConfigurationsListByResourceGroup_564171, schemes: {Scheme.Https})
type
  Call_RecommendationsGet_564191 = ref object of OpenApiRestCall_563556
proc url_RecommendationsGet_564193(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "recommendationId" in path,
        "`recommendationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/recommendations/"),
               (kind: VariableSegment, value: "recommendationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecommendationsGet_564192(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Obtains details of a cached recommendation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_564194 = path.getOrDefault("resourceUri")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceUri", valid_564194
  var valid_564195 = path.getOrDefault("recommendationId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "recommendationId", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564197: Call_RecommendationsGet_564191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains details of a cached recommendation.
  ## 
  let valid = call_564197.validator(path, query, header, formData, body)
  let scheme = call_564197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564197.url(scheme.get, call_564197.host, call_564197.base,
                         call_564197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564197, url, valid)

proc call*(call_564198: Call_RecommendationsGet_564191; apiVersion: string;
          resourceUri: string; recommendationId: string): Recallable =
  ## recommendationsGet
  ## Obtains details of a cached recommendation.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  var path_564199 = newJObject()
  var query_564200 = newJObject()
  add(query_564200, "api-version", newJString(apiVersion))
  add(path_564199, "resourceUri", newJString(resourceUri))
  add(path_564199, "recommendationId", newJString(recommendationId))
  result = call_564198.call(path_564199, query_564200, nil, nil, nil)

var recommendationsGet* = Call_RecommendationsGet_564191(
    name: "recommendationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}",
    validator: validate_RecommendationsGet_564192, base: "",
    url: url_RecommendationsGet_564193, schemes: {Scheme.Https})
type
  Call_SuppressionsCreate_564212 = ref object of OpenApiRestCall_563556
proc url_SuppressionsCreate_564214(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "recommendationId" in path,
        "`recommendationId` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/recommendations/"),
               (kind: VariableSegment, value: "recommendationId"),
               (kind: ConstantSegment, value: "/suppressions/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SuppressionsCreate_564213(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Enables the snoozed or dismissed attribute of a recommendation. The snoozed or dismissed attribute is referred to as a suppression. Use this API to create or update the snoozed or dismissed status of a recommendation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the suppression.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564215 = path.getOrDefault("name")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "name", valid_564215
  var valid_564216 = path.getOrDefault("resourceUri")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "resourceUri", valid_564216
  var valid_564217 = path.getOrDefault("recommendationId")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "recommendationId", valid_564217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564218 = query.getOrDefault("api-version")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = nil)
  if valid_564218 != nil:
    section.add "api-version", valid_564218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   suppressionContract: JObject (required)
  ##                      : The snoozed or dismissed attribute; for example, the snooze duration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564220: Call_SuppressionsCreate_564212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables the snoozed or dismissed attribute of a recommendation. The snoozed or dismissed attribute is referred to as a suppression. Use this API to create or update the snoozed or dismissed status of a recommendation.
  ## 
  let valid = call_564220.validator(path, query, header, formData, body)
  let scheme = call_564220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564220.url(scheme.get, call_564220.host, call_564220.base,
                         call_564220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564220, url, valid)

proc call*(call_564221: Call_SuppressionsCreate_564212;
          suppressionContract: JsonNode; apiVersion: string; name: string;
          resourceUri: string; recommendationId: string): Recallable =
  ## suppressionsCreate
  ## Enables the snoozed or dismissed attribute of a recommendation. The snoozed or dismissed attribute is referred to as a suppression. Use this API to create or update the snoozed or dismissed status of a recommendation.
  ##   suppressionContract: JObject (required)
  ##                      : The snoozed or dismissed attribute; for example, the snooze duration.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : The name of the suppression.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  var path_564222 = newJObject()
  var query_564223 = newJObject()
  var body_564224 = newJObject()
  if suppressionContract != nil:
    body_564224 = suppressionContract
  add(query_564223, "api-version", newJString(apiVersion))
  add(path_564222, "name", newJString(name))
  add(path_564222, "resourceUri", newJString(resourceUri))
  add(path_564222, "recommendationId", newJString(recommendationId))
  result = call_564221.call(path_564222, query_564223, nil, nil, body_564224)

var suppressionsCreate* = Call_SuppressionsCreate_564212(
    name: "suppressionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}/suppressions/{name}",
    validator: validate_SuppressionsCreate_564213, base: "",
    url: url_SuppressionsCreate_564214, schemes: {Scheme.Https})
type
  Call_SuppressionsGet_564201 = ref object of OpenApiRestCall_563556
proc url_SuppressionsGet_564203(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "recommendationId" in path,
        "`recommendationId` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/recommendations/"),
               (kind: VariableSegment, value: "recommendationId"),
               (kind: ConstantSegment, value: "/suppressions/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SuppressionsGet_564202(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Obtains the details of a suppression.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the suppression.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564204 = path.getOrDefault("name")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "name", valid_564204
  var valid_564205 = path.getOrDefault("resourceUri")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "resourceUri", valid_564205
  var valid_564206 = path.getOrDefault("recommendationId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "recommendationId", valid_564206
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564207 = query.getOrDefault("api-version")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "api-version", valid_564207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564208: Call_SuppressionsGet_564201; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the details of a suppression.
  ## 
  let valid = call_564208.validator(path, query, header, formData, body)
  let scheme = call_564208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564208.url(scheme.get, call_564208.host, call_564208.base,
                         call_564208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564208, url, valid)

proc call*(call_564209: Call_SuppressionsGet_564201; apiVersion: string;
          name: string; resourceUri: string; recommendationId: string): Recallable =
  ## suppressionsGet
  ## Obtains the details of a suppression.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : The name of the suppression.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  var path_564210 = newJObject()
  var query_564211 = newJObject()
  add(query_564211, "api-version", newJString(apiVersion))
  add(path_564210, "name", newJString(name))
  add(path_564210, "resourceUri", newJString(resourceUri))
  add(path_564210, "recommendationId", newJString(recommendationId))
  result = call_564209.call(path_564210, query_564211, nil, nil, nil)

var suppressionsGet* = Call_SuppressionsGet_564201(name: "suppressionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}/suppressions/{name}",
    validator: validate_SuppressionsGet_564202, base: "", url: url_SuppressionsGet_564203,
    schemes: {Scheme.Https})
type
  Call_SuppressionsDelete_564225 = ref object of OpenApiRestCall_563556
proc url_SuppressionsDelete_564227(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "recommendationId" in path,
        "`recommendationId` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Advisor/recommendations/"),
               (kind: VariableSegment, value: "recommendationId"),
               (kind: ConstantSegment, value: "/suppressions/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SuppressionsDelete_564226(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Enables the activation of a snoozed or dismissed recommendation. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the suppression.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_564228 = path.getOrDefault("name")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "name", valid_564228
  var valid_564229 = path.getOrDefault("resourceUri")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceUri", valid_564229
  var valid_564230 = path.getOrDefault("recommendationId")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = nil)
  if valid_564230 != nil:
    section.add "recommendationId", valid_564230
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = nil)
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564232: Call_SuppressionsDelete_564225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables the activation of a snoozed or dismissed recommendation. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  let valid = call_564232.validator(path, query, header, formData, body)
  let scheme = call_564232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564232.url(scheme.get, call_564232.host, call_564232.base,
                         call_564232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564232, url, valid)

proc call*(call_564233: Call_SuppressionsDelete_564225; apiVersion: string;
          name: string; resourceUri: string; recommendationId: string): Recallable =
  ## suppressionsDelete
  ## Enables the activation of a snoozed or dismissed recommendation. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : The name of the suppression.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  var path_564234 = newJObject()
  var query_564235 = newJObject()
  add(query_564235, "api-version", newJString(apiVersion))
  add(path_564234, "name", newJString(name))
  add(path_564234, "resourceUri", newJString(resourceUri))
  add(path_564234, "recommendationId", newJString(recommendationId))
  result = call_564233.call(path_564234, query_564235, nil, nil, nil)

var suppressionsDelete* = Call_SuppressionsDelete_564225(
    name: "suppressionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}/suppressions/{name}",
    validator: validate_SuppressionsDelete_564226, base: "",
    url: url_SuppressionsDelete_564227, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
