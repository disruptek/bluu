
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "subscription-subscriptionDefinitions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionDefinitionsOperationMetadataList_567863 = ref object of OpenApiRestCall_567641
proc url_SubscriptionDefinitionsOperationMetadataList_567865(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionDefinitionsOperationMetadataList_567864(path: JsonNode;
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
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568047: Call_SubscriptionDefinitionsOperationMetadataList_567863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Subscription API operations.
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_SubscriptionDefinitionsOperationMetadataList_567863;
          apiVersion: string): Recallable =
  ## subscriptionDefinitionsOperationMetadataList
  ## Lists all of the available Microsoft.Subscription API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var subscriptionDefinitionsOperationMetadataList* = Call_SubscriptionDefinitionsOperationMetadataList_567863(
    name: "subscriptionDefinitionsOperationMetadataList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Subscription/operations",
    validator: validate_SubscriptionDefinitionsOperationMetadataList_567864,
    base: "", url: url_SubscriptionDefinitionsOperationMetadataList_567865,
    schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsList_568159 = ref object of OpenApiRestCall_567641
proc url_SubscriptionDefinitionsList_568161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionDefinitionsList_568160(path: JsonNode; query: JsonNode;
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
  var valid_568162 = query.getOrDefault("api-version")
  valid_568162 = validateParameter(valid_568162, JString, required = true,
                                 default = nil)
  if valid_568162 != nil:
    section.add "api-version", valid_568162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568163: Call_SubscriptionDefinitionsList_568159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List an Azure subscription definition by subscriptionId.
  ## 
  let valid = call_568163.validator(path, query, header, formData, body)
  let scheme = call_568163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568163.url(scheme.get, call_568163.host, call_568163.base,
                         call_568163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568163, url, valid)

proc call*(call_568164: Call_SubscriptionDefinitionsList_568159; apiVersion: string): Recallable =
  ## subscriptionDefinitionsList
  ## List an Azure subscription definition by subscriptionId.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  var query_568165 = newJObject()
  add(query_568165, "api-version", newJString(apiVersion))
  result = call_568164.call(nil, query_568165, nil, nil, nil)

var subscriptionDefinitionsList* = Call_SubscriptionDefinitionsList_568159(
    name: "subscriptionDefinitionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.Subscription/subscriptionDefinitions",
    validator: validate_SubscriptionDefinitionsList_568160, base: "",
    url: url_SubscriptionDefinitionsList_568161, schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsCreate_568189 = ref object of OpenApiRestCall_567641
proc url_SubscriptionDefinitionsCreate_568191(protocol: Scheme; host: string;
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

proc validate_SubscriptionDefinitionsCreate_568190(path: JsonNode; query: JsonNode;
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
  var valid_568209 = path.getOrDefault("subscriptionDefinitionName")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = nil)
  if valid_568209 != nil:
    section.add "subscriptionDefinitionName", valid_568209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568210 = query.getOrDefault("api-version")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "api-version", valid_568210
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

proc call*(call_568212: Call_SubscriptionDefinitionsCreate_568189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create an Azure subscription definition.
  ## 
  let valid = call_568212.validator(path, query, header, formData, body)
  let scheme = call_568212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568212.url(scheme.get, call_568212.host, call_568212.base,
                         call_568212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568212, url, valid)

proc call*(call_568213: Call_SubscriptionDefinitionsCreate_568189;
          apiVersion: string; subscriptionDefinitionName: string; body: JsonNode): Recallable =
  ## subscriptionDefinitionsCreate
  ## Create an Azure subscription definition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionDefinitionName: string (required)
  ##                             : The name of the Azure subscription definition.
  ##   body: JObject (required)
  ##       : The subscription definition creation.
  var path_568214 = newJObject()
  var query_568215 = newJObject()
  var body_568216 = newJObject()
  add(query_568215, "api-version", newJString(apiVersion))
  add(path_568214, "subscriptionDefinitionName",
      newJString(subscriptionDefinitionName))
  if body != nil:
    body_568216 = body
  result = call_568213.call(path_568214, query_568215, nil, nil, body_568216)

var subscriptionDefinitionsCreate* = Call_SubscriptionDefinitionsCreate_568189(
    name: "subscriptionDefinitionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionDefinitions/{subscriptionDefinitionName}",
    validator: validate_SubscriptionDefinitionsCreate_568190, base: "",
    url: url_SubscriptionDefinitionsCreate_568191, schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsGet_568166 = ref object of OpenApiRestCall_567641
proc url_SubscriptionDefinitionsGet_568168(protocol: Scheme; host: string;
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

proc validate_SubscriptionDefinitionsGet_568167(path: JsonNode; query: JsonNode;
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
  var valid_568183 = path.getOrDefault("subscriptionDefinitionName")
  valid_568183 = validateParameter(valid_568183, JString, required = true,
                                 default = nil)
  if valid_568183 != nil:
    section.add "subscriptionDefinitionName", valid_568183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568184 = query.getOrDefault("api-version")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "api-version", valid_568184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568185: Call_SubscriptionDefinitionsGet_568166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an Azure subscription definition.
  ## 
  let valid = call_568185.validator(path, query, header, formData, body)
  let scheme = call_568185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568185.url(scheme.get, call_568185.host, call_568185.base,
                         call_568185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568185, url, valid)

proc call*(call_568186: Call_SubscriptionDefinitionsGet_568166; apiVersion: string;
          subscriptionDefinitionName: string): Recallable =
  ## subscriptionDefinitionsGet
  ## Get an Azure subscription definition.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   subscriptionDefinitionName: string (required)
  ##                             : The name of the Azure subscription definition.
  var path_568187 = newJObject()
  var query_568188 = newJObject()
  add(query_568188, "api-version", newJString(apiVersion))
  add(path_568187, "subscriptionDefinitionName",
      newJString(subscriptionDefinitionName))
  result = call_568186.call(path_568187, query_568188, nil, nil, nil)

var subscriptionDefinitionsGet* = Call_SubscriptionDefinitionsGet_568166(
    name: "subscriptionDefinitionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionDefinitions/{subscriptionDefinitionName}",
    validator: validate_SubscriptionDefinitionsGet_568167, base: "",
    url: url_SubscriptionDefinitionsGet_568168, schemes: {Scheme.Https})
type
  Call_SubscriptionDefinitionsGetOperationStatus_568217 = ref object of OpenApiRestCall_567641
proc url_SubscriptionDefinitionsGetOperationStatus_568219(protocol: Scheme;
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

proc validate_SubscriptionDefinitionsGetOperationStatus_568218(path: JsonNode;
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
  var valid_568220 = path.getOrDefault("operationId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "operationId", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2015-06-01
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568222: Call_SubscriptionDefinitionsGetOperationStatus_568217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the status of the subscription definition PUT operation. The URI of this API is returned in the Location field of the response header.
  ## 
  let valid = call_568222.validator(path, query, header, formData, body)
  let scheme = call_568222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568222.url(scheme.get, call_568222.host, call_568222.base,
                         call_568222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568222, url, valid)

proc call*(call_568223: Call_SubscriptionDefinitionsGetOperationStatus_568217;
          apiVersion: string; operationId: string): Recallable =
  ## subscriptionDefinitionsGetOperationStatus
  ## Retrieves the status of the subscription definition PUT operation. The URI of this API is returned in the Location field of the response header.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2015-06-01
  ##   operationId: string (required)
  ##              : The operation ID, which can be found from the Location field in the generate recommendation response header.
  var path_568224 = newJObject()
  var query_568225 = newJObject()
  add(query_568225, "api-version", newJString(apiVersion))
  add(path_568224, "operationId", newJString(operationId))
  result = call_568223.call(path_568224, query_568225, nil, nil, nil)

var subscriptionDefinitionsGetOperationStatus* = Call_SubscriptionDefinitionsGetOperationStatus_568217(
    name: "subscriptionDefinitionsGetOperationStatus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/providers/Microsoft.Subscription/subscriptionOperations/{operationId}",
    validator: validate_SubscriptionDefinitionsGetOperationStatus_568218,
    base: "", url: url_SubscriptionDefinitionsGetOperationStatus_568219,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
