
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Resource Graph
## version: 2018-09-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Resource Graph API Reference
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
  macServiceName = "resourcegraph"
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
  ## Lists all of the available REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
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
  ## Lists all of the available REST API operations.
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
  ## Lists all of the available REST API operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568135 = newJObject()
  add(query_568135, "api-version", newJString(apiVersion))
  result = call_568134.call(nil, query_568135, nil, nil, nil)

var operationsList* = Call_OperationsList_567879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ResourceGraph/operations",
    validator: validate_OperationsList_567880, base: "", url: url_OperationsList_567881,
    schemes: {Scheme.Https})
type
  Call_ResourceChangeDetails_568175 = ref object of OpenApiRestCall_567657
proc url_ResourceChangeDetails_568177(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ResourceChangeDetails_568176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get resource change details.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568178 = query.getOrDefault("api-version")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "api-version", valid_568178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for this request for resource change details.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568180: Call_ResourceChangeDetails_568175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get resource change details.
  ## 
  let valid = call_568180.validator(path, query, header, formData, body)
  let scheme = call_568180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568180.url(scheme.get, call_568180.host, call_568180.base,
                         call_568180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568180, url, valid)

proc call*(call_568181: Call_ResourceChangeDetails_568175; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## resourceChangeDetails
  ## Get resource change details.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : The parameters for this request for resource change details.
  var query_568182 = newJObject()
  var body_568183 = newJObject()
  add(query_568182, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568183 = parameters
  result = call_568181.call(nil, query_568182, nil, nil, body_568183)

var resourceChangeDetails* = Call_ResourceChangeDetails_568175(
    name: "resourceChangeDetails", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.ResourceGraph/resourceChangeDetails",
    validator: validate_ResourceChangeDetails_568176, base: "",
    url: url_ResourceChangeDetails_568177, schemes: {Scheme.Https})
type
  Call_ResourceChanges_568184 = ref object of OpenApiRestCall_567657
proc url_ResourceChanges_568186(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ResourceChanges_568185(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## List changes to a resource for a given time interval.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : the parameters for this request for changes.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568189: Call_ResourceChanges_568184; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List changes to a resource for a given time interval.
  ## 
  let valid = call_568189.validator(path, query, header, formData, body)
  let scheme = call_568189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568189.url(scheme.get, call_568189.host, call_568189.base,
                         call_568189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568189, url, valid)

proc call*(call_568190: Call_ResourceChanges_568184; apiVersion: string;
          parameters: JsonNode): Recallable =
  ## resourceChanges
  ## List changes to a resource for a given time interval.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : the parameters for this request for changes.
  var query_568191 = newJObject()
  var body_568192 = newJObject()
  add(query_568191, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568192 = parameters
  result = call_568190.call(nil, query_568191, nil, nil, body_568192)

var resourceChanges* = Call_ResourceChanges_568184(name: "resourceChanges",
    meth: HttpMethod.HttpPost, host: "management.azure.com",
    route: "/providers/Microsoft.ResourceGraph/resourceChanges",
    validator: validate_ResourceChanges_568185, base: "", url: url_ResourceChanges_568186,
    schemes: {Scheme.Https})
type
  Call_Resources_568193 = ref object of OpenApiRestCall_567657
proc url_Resources_568195(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_Resources_568194(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries the resources managed by Azure Resource Manager for all subscriptions specified in the request.
  ## 
  ## Learn more about the query syntax here
  ## https://aka.ms/resource-graph/learntoquery
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568196 = query.getOrDefault("api-version")
  valid_568196 = validateParameter(valid_568196, JString, required = true,
                                 default = nil)
  if valid_568196 != nil:
    section.add "api-version", valid_568196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   query: JObject (required)
  ##        : Request specifying query and its options.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568198: Call_Resources_568193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Queries the resources managed by Azure Resource Manager for all subscriptions specified in the request.
  ## 
  ## Learn more about the query syntax here
  ## https://aka.ms/resource-graph/learntoquery
  let valid = call_568198.validator(path, query, header, formData, body)
  let scheme = call_568198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568198.url(scheme.get, call_568198.host, call_568198.base,
                         call_568198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568198, url, valid)

proc call*(call_568199: Call_Resources_568193; apiVersion: string; query: JsonNode): Recallable =
  ## resources
  ## Queries the resources managed by Azure Resource Manager for all subscriptions specified in the request.
  ## Learn more about the query syntax here
  ## https://aka.ms/resource-graph/learntoquery
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   query: JObject (required)
  ##        : Request specifying query and its options.
  var query_568200 = newJObject()
  var body_568201 = newJObject()
  add(query_568200, "api-version", newJString(apiVersion))
  if query != nil:
    body_568201 = query
  result = call_568199.call(nil, query_568200, nil, nil, body_568201)

var resources* = Call_Resources_568193(name: "resources", meth: HttpMethod.HttpPost,
                                    host: "management.azure.com", route: "/providers/Microsoft.ResourceGraph/resources",
                                    validator: validate_Resources_568194,
                                    base: "", url: url_Resources_568195,
                                    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
