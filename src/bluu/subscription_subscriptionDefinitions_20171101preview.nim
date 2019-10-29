
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SubscriptionDefinitionsClient
## version: 2017-11-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Subscription definitions client provides an interface to create, modify and retrieve azure subscriptions programmatically.
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "subscription-subscriptionDefinitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionDefinitionsOperationMetadataList_563761 = ref object of OpenApiRestCall_563539
proc url_SubscriptionDefinitionsOperationMetadataList_563763(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionDefinitionsOperationMetadataList_563762(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Subscription API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563924 = query.getOrDefault("api-version")
  valid_563924 = validateParameter(valid_563924, JString, required = true,
                                 default = nil)
  if valid_563924 != nil:
    section.add "api-version", valid_563924
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563947: Call_SubscriptionDefinitionsOperationMetadataList_563761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Subscription API operations.
  ## 
  let valid = call_563947.validator(path, query, header, formData, body)
  let scheme = call_563947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563947.url(scheme.get, call_563947.host, call_563947.base,
                         call_563947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563947, url, valid)

proc call*(call_564018: Call_SubscriptionDefinitionsOperationMetadataList_563761;
          apiVersion: string): Recallable =
  ## subscriptionDefinitionsOperationMetadataList
  ## Lists all of the available Microsoft.Subscription API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  var query_564019 = newJObject()
  add(query_564019, "api-version", newJString(apiVersion))
  result = call_564018.call(nil, query_564019, nil, nil, nil)

var subscriptionDefinitionsOperationMetadataList* = Call_SubscriptionDefinitionsOperationMetadataList_563761(
    name: "subscriptionDefinitionsOperationMetadataList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Subscription/operations",
    validator: validate_SubscriptionDefinitionsOperationMetadataList_563762,
    base: "", url: url_SubscriptionDefinitionsOperationMetadataList_563763,
    schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsList_564059 = ref object of OpenApiRestCall_563539
proc url_SubscriptionDefinitionsList_564061(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionDefinitionsList_564060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List an Azure subscription definition by subscriptionId.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564062 = query.getOrDefault("api-version")
  valid_564062 = validateParameter(valid_564062, JString, required = true,
                                 default = nil)
  if valid_564062 != nil:
    section.add "api-version", valid_564062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564063: Call_SubscriptionDefinitionsList_564059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List an Azure subscription definition by subscriptionId.
  ## 
  let valid = call_564063.validator(path, query, header, formData, body)
  let scheme = call_564063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564063.url(scheme.get, call_564063.host, call_564063.base,
                         call_564063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564063, url, valid)

proc call*(call_564064: Call_SubscriptionDefinitionsList_564059; apiVersion: string): Recallable =
  ## subscriptionDefinitionsList
  ## List an Azure subscription definition by subscriptionId.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  var query_564065 = newJObject()
  add(query_564065, "api-version", newJString(apiVersion))
  result = call_564064.call(nil, query_564065, nil, nil, nil)

var subscriptionDefinitionsList* = Call_SubscriptionDefinitionsList_564059(
    name: "subscriptionDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Subscription/subscriptionDefinitions",
    validator: validate_SubscriptionDefinitionsList_564060, base: "",
    url: url_SubscriptionDefinitionsList_564061, schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsCreate_564089 = ref object of OpenApiRestCall_563539
proc url_SubscriptionDefinitionsCreate_564091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionDefinitionName" in path,
        "`subscriptionDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.Subscription/subscriptionDefinitions/"),
               (kind: VariableSegment, value: "subscriptionDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionDefinitionsCreate_564090(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an Azure subscription definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionDefinitionName: JString (required)
  ##                             : The name of the Azure subscription definition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `subscriptionDefinitionName` field"
  var valid_564109 = path.getOrDefault("subscriptionDefinitionName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "subscriptionDefinitionName", valid_564109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
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
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The subscription definition creation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564112: Call_SubscriptionDefinitionsCreate_564089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Azure subscription definition.
  ## 
  let valid = call_564112.validator(path, query, header, formData, body)
  let scheme = call_564112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564112.url(scheme.get, call_564112.host, call_564112.base,
                         call_564112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564112, url, valid)

proc call*(call_564113: Call_SubscriptionDefinitionsCreate_564089;
          apiVersion: string; subscriptionDefinitionName: string; body: JsonNode): Recallable =
  ## subscriptionDefinitionsCreate
  ## Create an Azure subscription definition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionDefinitionName: string (required)
  ##                             : The name of the Azure subscription definition.
  ##   body: JObject (required)
  ##       : The subscription definition creation.
  var path_564114 = newJObject()
  var query_564115 = newJObject()
  var body_564116 = newJObject()
  add(query_564115, "api-version", newJString(apiVersion))
  add(path_564114, "subscriptionDefinitionName",
      newJString(subscriptionDefinitionName))
  if body != nil:
    body_564116 = body
  result = call_564113.call(path_564114, query_564115, nil, nil, body_564116)

var subscriptionDefinitionsCreate* = Call_SubscriptionDefinitionsCreate_564089(
    name: "subscriptionDefinitionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionDefinitions/{subscriptionDefinitionName}",
    validator: validate_SubscriptionDefinitionsCreate_564090, base: "",
    url: url_SubscriptionDefinitionsCreate_564091, schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsGet_564066 = ref object of OpenApiRestCall_563539
proc url_SubscriptionDefinitionsGet_564068(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionDefinitionName" in path,
        "`subscriptionDefinitionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.Subscription/subscriptionDefinitions/"),
               (kind: VariableSegment, value: "subscriptionDefinitionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionDefinitionsGet_564067(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get an Azure subscription definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionDefinitionName: JString (required)
  ##                             : The name of the Azure subscription definition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `subscriptionDefinitionName` field"
  var valid_564083 = path.getOrDefault("subscriptionDefinitionName")
  valid_564083 = validateParameter(valid_564083, JString, required = true,
                                 default = nil)
  if valid_564083 != nil:
    section.add "subscriptionDefinitionName", valid_564083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564084 = query.getOrDefault("api-version")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "api-version", valid_564084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564085: Call_SubscriptionDefinitionsGet_564066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an Azure subscription definition.
  ## 
  let valid = call_564085.validator(path, query, header, formData, body)
  let scheme = call_564085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564085.url(scheme.get, call_564085.host, call_564085.base,
                         call_564085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564085, url, valid)

proc call*(call_564086: Call_SubscriptionDefinitionsGet_564066; apiVersion: string;
          subscriptionDefinitionName: string): Recallable =
  ## subscriptionDefinitionsGet
  ## Get an Azure subscription definition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionDefinitionName: string (required)
  ##                             : The name of the Azure subscription definition.
  var path_564087 = newJObject()
  var query_564088 = newJObject()
  add(query_564088, "api-version", newJString(apiVersion))
  add(path_564087, "subscriptionDefinitionName",
      newJString(subscriptionDefinitionName))
  result = call_564086.call(path_564087, query_564088, nil, nil, nil)

var subscriptionDefinitionsGet* = Call_SubscriptionDefinitionsGet_564066(
    name: "subscriptionDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionDefinitions/{subscriptionDefinitionName}",
    validator: validate_SubscriptionDefinitionsGet_564067, base: "",
    url: url_SubscriptionDefinitionsGet_564068, schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsGetOperationStatus_564117 = ref object of OpenApiRestCall_563539
proc url_SubscriptionDefinitionsGetOperationStatus_564119(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/Microsoft.Subscription/subscriptionOperations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionDefinitionsGetOperationStatus_564118(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the status of the subscription definition PUT operation. The URI of this API is returned in the Location field of the response header.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   operationId: JString (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `operationId` field"
  var valid_564120 = path.getOrDefault("operationId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "operationId", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
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

proc call*(call_564122: Call_SubscriptionDefinitionsGetOperationStatus_564117;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the status of the subscription definition PUT operation. The URI of this API is returned in the Location field of the response header.
  ## 
  let valid = call_564122.validator(path, query, header, formData, body)
  let scheme = call_564122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564122.url(scheme.get, call_564122.host, call_564122.base,
                         call_564122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564122, url, valid)

proc call*(call_564123: Call_SubscriptionDefinitionsGetOperationStatus_564117;
          apiVersion: string; operationId: string): Recallable =
  ## subscriptionDefinitionsGetOperationStatus
  ## Retrieves the status of the subscription definition PUT operation. The URI of this API is returned in the Location field of the response header.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   operationId: string (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  var path_564124 = newJObject()
  var query_564125 = newJObject()
  add(query_564125, "api-version", newJString(apiVersion))
  add(path_564124, "operationId", newJString(operationId))
  result = call_564123.call(path_564124, query_564125, nil, nil, nil)

var subscriptionDefinitionsGetOperationStatus* = Call_SubscriptionDefinitionsGetOperationStatus_564117(
    name: "subscriptionDefinitionsGetOperationStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionOperations/{operationId}",
    validator: validate_SubscriptionDefinitionsGetOperationStatus_564118,
    base: "", url: url_SubscriptionDefinitionsGetOperationStatus_564119,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
