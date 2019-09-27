
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
  macServiceName = "advisor"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RecommendationMetadataList_593647 = ref object of OpenApiRestCall_593425
proc url_RecommendationMetadataList_593649(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecommendationMetadataList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_RecommendationMetadataList_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_RecommendationMetadataList_593647; apiVersion: string): Recallable =
  ## recommendationMetadataList
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var recommendationMetadataList* = Call_RecommendationMetadataList_593647(
    name: "recommendationMetadataList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Advisor/metadata",
    validator: validate_RecommendationMetadataList_593648, base: "",
    url: url_RecommendationMetadataList_593649, schemes: {Scheme.Https})
type
  Call_RecommendationMetadataGet_593943 = ref object of OpenApiRestCall_593425
proc url_RecommendationMetadataGet_593945(protocol: Scheme; host: string;
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

proc validate_RecommendationMetadataGet_593944(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of metadata entity.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_593960 = path.getOrDefault("name")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "name", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_RecommendationMetadataGet_593943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_RecommendationMetadataGet_593943; apiVersion: string;
          name: string): Recallable =
  ## recommendationMetadataGet
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : Name of metadata entity.
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  add(query_593965, "api-version", newJString(apiVersion))
  add(path_593964, "name", newJString(name))
  result = call_593963.call(path_593964, query_593965, nil, nil, nil)

var recommendationMetadataGet* = Call_RecommendationMetadataGet_593943(
    name: "recommendationMetadataGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Advisor/metadata/{name}",
    validator: validate_RecommendationMetadataGet_593944, base: "",
    url: url_RecommendationMetadataGet_593945, schemes: {Scheme.Https})
type
  Call_OperationsList_593966 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593968(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593967(path: JsonNode; query: JsonNode;
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
  var valid_593969 = query.getOrDefault("api-version")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "api-version", valid_593969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_OperationsList_593966; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available Advisor REST API operations.
  ## 
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_OperationsList_593966; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all the available Advisor REST API operations.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  var query_593972 = newJObject()
  add(query_593972, "api-version", newJString(apiVersion))
  result = call_593971.call(nil, query_593972, nil, nil, nil)

var operationsList* = Call_OperationsList_593966(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Advisor/operations",
    validator: validate_OperationsList_593967, base: "", url: url_OperationsList_593968,
    schemes: {Scheme.Https})
type
  Call_ConfigurationsCreateInSubscription_593982 = ref object of OpenApiRestCall_593425
proc url_ConfigurationsCreateInSubscription_593984(protocol: Scheme; host: string;
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

proc validate_ConfigurationsCreateInSubscription_593983(path: JsonNode;
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
  var valid_593985 = path.getOrDefault("subscriptionId")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "subscriptionId", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = nil)
  if valid_593986 != nil:
    section.add "api-version", valid_593986
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

proc call*(call_593988: Call_ConfigurationsCreateInSubscription_593982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create/Overwrite Azure Advisor configuration and also delete all configurations of contained resource groups.
  ## 
  let valid = call_593988.validator(path, query, header, formData, body)
  let scheme = call_593988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593988.url(scheme.get, call_593988.host, call_593988.base,
                         call_593988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593988, url, valid)

proc call*(call_593989: Call_ConfigurationsCreateInSubscription_593982;
          apiVersion: string; subscriptionId: string; configContract: JsonNode): Recallable =
  ## configurationsCreateInSubscription
  ## Create/Overwrite Azure Advisor configuration and also delete all configurations of contained resource groups.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   configContract: JObject (required)
  ##                 : The Azure Advisor configuration data structure.
  var path_593990 = newJObject()
  var query_593991 = newJObject()
  var body_593992 = newJObject()
  add(query_593991, "api-version", newJString(apiVersion))
  add(path_593990, "subscriptionId", newJString(subscriptionId))
  if configContract != nil:
    body_593992 = configContract
  result = call_593989.call(path_593990, query_593991, nil, nil, body_593992)

var configurationsCreateInSubscription* = Call_ConfigurationsCreateInSubscription_593982(
    name: "configurationsCreateInSubscription", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/configurations",
    validator: validate_ConfigurationsCreateInSubscription_593983, base: "",
    url: url_ConfigurationsCreateInSubscription_593984, schemes: {Scheme.Https})
type
  Call_ConfigurationsListBySubscription_593973 = ref object of OpenApiRestCall_593425
proc url_ConfigurationsListBySubscription_593975(protocol: Scheme; host: string;
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

proc validate_ConfigurationsListBySubscription_593974(path: JsonNode;
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
  var valid_593976 = path.getOrDefault("subscriptionId")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = nil)
  if valid_593976 != nil:
    section.add "subscriptionId", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = nil)
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_ConfigurationsListBySubscription_593973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve Azure Advisor configurations and also retrieve configurations of contained resource groups.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_ConfigurationsListBySubscription_593973;
          apiVersion: string; subscriptionId: string): Recallable =
  ## configurationsListBySubscription
  ## Retrieve Azure Advisor configurations and also retrieve configurations of contained resource groups.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var configurationsListBySubscription* = Call_ConfigurationsListBySubscription_593973(
    name: "configurationsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/configurations",
    validator: validate_ConfigurationsListBySubscription_593974, base: "",
    url: url_ConfigurationsListBySubscription_593975, schemes: {Scheme.Https})
type
  Call_RecommendationsGenerate_593993 = ref object of OpenApiRestCall_593425
proc url_RecommendationsGenerate_593995(protocol: Scheme; host: string; base: string;
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

proc validate_RecommendationsGenerate_593994(path: JsonNode; query: JsonNode;
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
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593997 = query.getOrDefault("api-version")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "api-version", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_RecommendationsGenerate_593993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initiates the recommendation generation or computation process for a subscription. This operation is asynchronous. The generated recommendations are stored in a cache in the Advisor service.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_RecommendationsGenerate_593993; apiVersion: string;
          subscriptionId: string): Recallable =
  ## recommendationsGenerate
  ## Initiates the recommendation generation or computation process for a subscription. This operation is asynchronous. The generated recommendations are stored in a cache in the Advisor service.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var recommendationsGenerate* = Call_RecommendationsGenerate_593993(
    name: "recommendationsGenerate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/generateRecommendations",
    validator: validate_RecommendationsGenerate_593994, base: "",
    url: url_RecommendationsGenerate_593995, schemes: {Scheme.Https})
type
  Call_RecommendationsGetGenerateStatus_594002 = ref object of OpenApiRestCall_593425
proc url_RecommendationsGetGenerateStatus_594004(protocol: Scheme; host: string;
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

proc validate_RecommendationsGetGenerateStatus_594003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the status of the recommendation computation or generation process. Invoke this API after calling the generation recommendation. The URI of this API is returned in the Location field of the response header.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   operationId: JString (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594005 = path.getOrDefault("subscriptionId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "subscriptionId", valid_594005
  var valid_594006 = path.getOrDefault("operationId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "operationId", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_RecommendationsGetGenerateStatus_594002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the status of the recommendation computation or generation process. Invoke this API after calling the generation recommendation. The URI of this API is returned in the Location field of the response header.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_RecommendationsGetGenerateStatus_594002;
          apiVersion: string; subscriptionId: string; operationId: string): Recallable =
  ## recommendationsGetGenerateStatus
  ## Retrieves the status of the recommendation computation or generation process. Invoke this API after calling the generation recommendation. The URI of this API is returned in the Location field of the response header.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   operationId: string (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  add(path_594010, "operationId", newJString(operationId))
  result = call_594009.call(path_594010, query_594011, nil, nil, nil)

var recommendationsGetGenerateStatus* = Call_RecommendationsGetGenerateStatus_594002(
    name: "recommendationsGetGenerateStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/generateRecommendations/{operationId}",
    validator: validate_RecommendationsGetGenerateStatus_594003, base: "",
    url: url_RecommendationsGetGenerateStatus_594004, schemes: {Scheme.Https})
type
  Call_RecommendationsList_594012 = ref object of OpenApiRestCall_593425
proc url_RecommendationsList_594014(protocol: Scheme; host: string; base: string;
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

proc validate_RecommendationsList_594013(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("subscriptionId")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "subscriptionId", valid_594016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of recommendations per page if a paged version of this API is being used.
  ##   $skipToken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $filter: JString
  ##          : The filter to apply to the recommendations.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "api-version", valid_594017
  var valid_594018 = query.getOrDefault("$top")
  valid_594018 = validateParameter(valid_594018, JInt, required = false, default = nil)
  if valid_594018 != nil:
    section.add "$top", valid_594018
  var valid_594019 = query.getOrDefault("$skipToken")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "$skipToken", valid_594019
  var valid_594020 = query.getOrDefault("$filter")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "$filter", valid_594020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594021: Call_RecommendationsList_594012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains cached recommendations for a subscription. The recommendations are generated or computed by invoking generateRecommendations.
  ## 
  let valid = call_594021.validator(path, query, header, formData, body)
  let scheme = call_594021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594021.url(scheme.get, call_594021.host, call_594021.base,
                         call_594021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594021, url, valid)

proc call*(call_594022: Call_RecommendationsList_594012; apiVersion: string;
          subscriptionId: string; Top: int = 0; SkipToken: string = "";
          Filter: string = ""): Recallable =
  ## recommendationsList
  ## Obtains cached recommendations for a subscription. The recommendations are generated or computed by invoking generateRecommendations.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Top: int
  ##      : The number of recommendations per page if a paged version of this API is being used.
  ##   SkipToken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Filter: string
  ##         : The filter to apply to the recommendations.
  var path_594023 = newJObject()
  var query_594024 = newJObject()
  add(query_594024, "api-version", newJString(apiVersion))
  add(path_594023, "subscriptionId", newJString(subscriptionId))
  add(query_594024, "$top", newJInt(Top))
  add(query_594024, "$skipToken", newJString(SkipToken))
  add(query_594024, "$filter", newJString(Filter))
  result = call_594022.call(path_594023, query_594024, nil, nil, nil)

var recommendationsList* = Call_RecommendationsList_594012(
    name: "recommendationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/recommendations",
    validator: validate_RecommendationsList_594013, base: "",
    url: url_RecommendationsList_594014, schemes: {Scheme.Https})
type
  Call_SuppressionsList_594025 = ref object of OpenApiRestCall_593425
proc url_SuppressionsList_594027(protocol: Scheme; host: string; base: string;
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

proc validate_SuppressionsList_594026(path: JsonNode; query: JsonNode;
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
  var valid_594028 = path.getOrDefault("subscriptionId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "subscriptionId", valid_594028
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  ##   $top: JInt
  ##       : The number of suppressions per page if a paged version of this API is being used.
  ##   $skipToken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594029 = query.getOrDefault("api-version")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "api-version", valid_594029
  var valid_594030 = query.getOrDefault("$top")
  valid_594030 = validateParameter(valid_594030, JInt, required = false, default = nil)
  if valid_594030 != nil:
    section.add "$top", valid_594030
  var valid_594031 = query.getOrDefault("$skipToken")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "$skipToken", valid_594031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594032: Call_SuppressionsList_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the list of snoozed or dismissed suppressions for a subscription. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  let valid = call_594032.validator(path, query, header, formData, body)
  let scheme = call_594032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594032.url(scheme.get, call_594032.host, call_594032.base,
                         call_594032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594032, url, valid)

proc call*(call_594033: Call_SuppressionsList_594025; apiVersion: string;
          subscriptionId: string; Top: int = 0; SkipToken: string = ""): Recallable =
  ## suppressionsList
  ## Retrieves the list of snoozed or dismissed suppressions for a subscription. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   Top: int
  ##      : The number of suppressions per page if a paged version of this API is being used.
  ##   SkipToken: string
  ##            : The page-continuation token to use with a paged version of this API.
  var path_594034 = newJObject()
  var query_594035 = newJObject()
  add(query_594035, "api-version", newJString(apiVersion))
  add(path_594034, "subscriptionId", newJString(subscriptionId))
  add(query_594035, "$top", newJInt(Top))
  add(query_594035, "$skipToken", newJString(SkipToken))
  result = call_594033.call(path_594034, query_594035, nil, nil, nil)

var suppressionsList* = Call_SuppressionsList_594025(name: "suppressionsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Advisor/suppressions",
    validator: validate_SuppressionsList_594026, base: "",
    url: url_SuppressionsList_594027, schemes: {Scheme.Https})
type
  Call_ConfigurationsCreateInResourceGroup_594046 = ref object of OpenApiRestCall_593425
proc url_ConfigurationsCreateInResourceGroup_594048(protocol: Scheme; host: string;
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

proc validate_ConfigurationsCreateInResourceGroup_594047(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The name of the Azure resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594049 = path.getOrDefault("subscriptionId")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "subscriptionId", valid_594049
  var valid_594050 = path.getOrDefault("resourceGroup")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroup", valid_594050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594051 = query.getOrDefault("api-version")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "api-version", valid_594051
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

proc call*(call_594053: Call_ConfigurationsCreateInResourceGroup_594046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_ConfigurationsCreateInResourceGroup_594046;
          apiVersion: string; subscriptionId: string; resourceGroup: string;
          configContract: JsonNode): Recallable =
  ## configurationsCreateInResourceGroup
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroup: string (required)
  ##                : The name of the Azure resource group.
  ##   configContract: JObject (required)
  ##                 : The Azure Advisor configuration data structure.
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  var body_594057 = newJObject()
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "subscriptionId", newJString(subscriptionId))
  add(path_594055, "resourceGroup", newJString(resourceGroup))
  if configContract != nil:
    body_594057 = configContract
  result = call_594054.call(path_594055, query_594056, nil, nil, body_594057)

var configurationsCreateInResourceGroup* = Call_ConfigurationsCreateInResourceGroup_594046(
    name: "configurationsCreateInResourceGroup", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Advisor/configurations",
    validator: validate_ConfigurationsCreateInResourceGroup_594047, base: "",
    url: url_ConfigurationsCreateInResourceGroup_594048, schemes: {Scheme.Https})
type
  Call_ConfigurationsListByResourceGroup_594036 = ref object of OpenApiRestCall_593425
proc url_ConfigurationsListByResourceGroup_594038(protocol: Scheme; host: string;
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

proc validate_ConfigurationsListByResourceGroup_594037(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroup: JString (required)
  ##                : The name of the Azure resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594039 = path.getOrDefault("subscriptionId")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "subscriptionId", valid_594039
  var valid_594040 = path.getOrDefault("resourceGroup")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "resourceGroup", valid_594040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594042: Call_ConfigurationsListByResourceGroup_594036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_ConfigurationsListByResourceGroup_594036;
          apiVersion: string; subscriptionId: string; resourceGroup: string): Recallable =
  ## configurationsListByResourceGroup
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription ID.
  ##   resourceGroup: string (required)
  ##                : The name of the Azure resource group.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  add(query_594045, "api-version", newJString(apiVersion))
  add(path_594044, "subscriptionId", newJString(subscriptionId))
  add(path_594044, "resourceGroup", newJString(resourceGroup))
  result = call_594043.call(path_594044, query_594045, nil, nil, nil)

var configurationsListByResourceGroup* = Call_ConfigurationsListByResourceGroup_594036(
    name: "configurationsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.Advisor/configurations",
    validator: validate_ConfigurationsListByResourceGroup_594037, base: "",
    url: url_ConfigurationsListByResourceGroup_594038, schemes: {Scheme.Https})
type
  Call_RecommendationsGet_594058 = ref object of OpenApiRestCall_593425
proc url_RecommendationsGet_594060(protocol: Scheme; host: string; base: string;
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

proc validate_RecommendationsGet_594059(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Obtains details of a cached recommendation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `recommendationId` field"
  var valid_594061 = path.getOrDefault("recommendationId")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "recommendationId", valid_594061
  var valid_594062 = path.getOrDefault("resourceUri")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "resourceUri", valid_594062
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
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

proc call*(call_594064: Call_RecommendationsGet_594058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains details of a cached recommendation.
  ## 
  let valid = call_594064.validator(path, query, header, formData, body)
  let scheme = call_594064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594064.url(scheme.get, call_594064.host, call_594064.base,
                         call_594064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594064, url, valid)

proc call*(call_594065: Call_RecommendationsGet_594058; apiVersion: string;
          recommendationId: string; resourceUri: string): Recallable =
  ## recommendationsGet
  ## Obtains details of a cached recommendation.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  var path_594066 = newJObject()
  var query_594067 = newJObject()
  add(query_594067, "api-version", newJString(apiVersion))
  add(path_594066, "recommendationId", newJString(recommendationId))
  add(path_594066, "resourceUri", newJString(resourceUri))
  result = call_594065.call(path_594066, query_594067, nil, nil, nil)

var recommendationsGet* = Call_RecommendationsGet_594058(
    name: "recommendationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}",
    validator: validate_RecommendationsGet_594059, base: "",
    url: url_RecommendationsGet_594060, schemes: {Scheme.Https})
type
  Call_SuppressionsCreate_594079 = ref object of OpenApiRestCall_593425
proc url_SuppressionsCreate_594081(protocol: Scheme; host: string; base: string;
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

proc validate_SuppressionsCreate_594080(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Enables the snoozed or dismissed attribute of a recommendation. The snoozed or dismissed attribute is referred to as a suppression. Use this API to create or update the snoozed or dismissed status of a recommendation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the suppression.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594082 = path.getOrDefault("name")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "name", valid_594082
  var valid_594083 = path.getOrDefault("recommendationId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "recommendationId", valid_594083
  var valid_594084 = path.getOrDefault("resourceUri")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "resourceUri", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
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

proc call*(call_594087: Call_SuppressionsCreate_594079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables the snoozed or dismissed attribute of a recommendation. The snoozed or dismissed attribute is referred to as a suppression. Use this API to create or update the snoozed or dismissed status of a recommendation.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_SuppressionsCreate_594079; apiVersion: string;
          name: string; recommendationId: string; suppressionContract: JsonNode;
          resourceUri: string): Recallable =
  ## suppressionsCreate
  ## Enables the snoozed or dismissed attribute of a recommendation. The snoozed or dismissed attribute is referred to as a suppression. Use this API to create or update the snoozed or dismissed status of a recommendation.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : The name of the suppression.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  ##   suppressionContract: JObject (required)
  ##                      : The snoozed or dismissed attribute; for example, the snooze duration.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  var body_594091 = newJObject()
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "name", newJString(name))
  add(path_594089, "recommendationId", newJString(recommendationId))
  if suppressionContract != nil:
    body_594091 = suppressionContract
  add(path_594089, "resourceUri", newJString(resourceUri))
  result = call_594088.call(path_594089, query_594090, nil, nil, body_594091)

var suppressionsCreate* = Call_SuppressionsCreate_594079(
    name: "suppressionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}/suppressions/{name}",
    validator: validate_SuppressionsCreate_594080, base: "",
    url: url_SuppressionsCreate_594081, schemes: {Scheme.Https})
type
  Call_SuppressionsGet_594068 = ref object of OpenApiRestCall_593425
proc url_SuppressionsGet_594070(protocol: Scheme; host: string; base: string;
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

proc validate_SuppressionsGet_594069(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Obtains the details of a suppression.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the suppression.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594071 = path.getOrDefault("name")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "name", valid_594071
  var valid_594072 = path.getOrDefault("recommendationId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "recommendationId", valid_594072
  var valid_594073 = path.getOrDefault("resourceUri")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "resourceUri", valid_594073
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
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
  if body != nil:
    result.add "body", body

proc call*(call_594075: Call_SuppressionsGet_594068; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Obtains the details of a suppression.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_SuppressionsGet_594068; apiVersion: string;
          name: string; recommendationId: string; resourceUri: string): Recallable =
  ## suppressionsGet
  ## Obtains the details of a suppression.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : The name of the suppression.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  add(query_594078, "api-version", newJString(apiVersion))
  add(path_594077, "name", newJString(name))
  add(path_594077, "recommendationId", newJString(recommendationId))
  add(path_594077, "resourceUri", newJString(resourceUri))
  result = call_594076.call(path_594077, query_594078, nil, nil, nil)

var suppressionsGet* = Call_SuppressionsGet_594068(name: "suppressionsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}/suppressions/{name}",
    validator: validate_SuppressionsGet_594069, base: "", url: url_SuppressionsGet_594070,
    schemes: {Scheme.Https})
type
  Call_SuppressionsDelete_594092 = ref object of OpenApiRestCall_593425
proc url_SuppressionsDelete_594094(protocol: Scheme; host: string; base: string;
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

proc validate_SuppressionsDelete_594093(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Enables the activation of a snoozed or dismissed recommendation. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the suppression.
  ##   recommendationId: JString (required)
  ##                   : The recommendation ID.
  ##   resourceUri: JString (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594095 = path.getOrDefault("name")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "name", valid_594095
  var valid_594096 = path.getOrDefault("recommendationId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "recommendationId", valid_594096
  var valid_594097 = path.getOrDefault("resourceUri")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "resourceUri", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594099: Call_SuppressionsDelete_594092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enables the activation of a snoozed or dismissed recommendation. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_SuppressionsDelete_594092; apiVersion: string;
          name: string; recommendationId: string; resourceUri: string): Recallable =
  ## suppressionsDelete
  ## Enables the activation of a snoozed or dismissed recommendation. The snoozed or dismissed attribute of a recommendation is referred to as a suppression.
  ##   apiVersion: string (required)
  ##             : The version of the API to be used with the client request.
  ##   name: string (required)
  ##       : The name of the suppression.
  ##   recommendationId: string (required)
  ##                   : The recommendation ID.
  ##   resourceUri: string (required)
  ##              : The fully qualified Azure Resource Manager identifier of the resource to which the recommendation applies.
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  add(query_594102, "api-version", newJString(apiVersion))
  add(path_594101, "name", newJString(name))
  add(path_594101, "recommendationId", newJString(recommendationId))
  add(path_594101, "resourceUri", newJString(resourceUri))
  result = call_594100.call(path_594101, query_594102, nil, nil, nil)

var suppressionsDelete* = Call_SuppressionsDelete_594092(
    name: "suppressionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.Advisor/recommendations/{recommendationId}/suppressions/{name}",
    validator: validate_SuppressionsDelete_594093, base: "",
    url: url_SuppressionsDelete_594094, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
