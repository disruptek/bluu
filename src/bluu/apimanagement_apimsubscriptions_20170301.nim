
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Subscription entity associated with your Azure API Management deployment. The Subscription entity represents the association between a user and a product in API Management. Products contain one or more APIs, and once a product is published, developers can subscribe to the product and begin to use the product’s APIs.
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

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimsubscriptions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionList_596679 = ref object of OpenApiRestCall_596457
proc url_SubscriptionList_596681(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionList_596680(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists all subscriptions of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $top: JInt
  ##       : Number of records to return.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596828 = query.getOrDefault("api-version")
  valid_596828 = validateParameter(valid_596828, JString, required = true,
                                 default = nil)
  if valid_596828 != nil:
    section.add "api-version", valid_596828
  var valid_596829 = query.getOrDefault("$top")
  valid_596829 = validateParameter(valid_596829, JInt, required = false, default = nil)
  if valid_596829 != nil:
    section.add "$top", valid_596829
  var valid_596830 = query.getOrDefault("$skip")
  valid_596830 = validateParameter(valid_596830, JInt, required = false, default = nil)
  if valid_596830 != nil:
    section.add "$skip", valid_596830
  var valid_596831 = query.getOrDefault("$filter")
  valid_596831 = validateParameter(valid_596831, JString, required = false,
                                 default = nil)
  if valid_596831 != nil:
    section.add "$filter", valid_596831
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596858: Call_SubscriptionList_596679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all subscriptions of the API Management service instance.
  ## 
  let valid = call_596858.validator(path, query, header, formData, body)
  let scheme = call_596858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596858.url(scheme.get, call_596858.host, call_596858.base,
                         call_596858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596858, url, valid)

proc call*(call_596929: Call_SubscriptionList_596679; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## subscriptionList
  ## Lists all subscriptions of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field        | Supported operators    | Supported functions                         |
  ## 
  ## |--------------|------------------------|---------------------------------------------|
  ## | id           | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name         | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | stateComment | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | userId       | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | productId    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | state        | eq                     |                                             |
  var query_596930 = newJObject()
  add(query_596930, "api-version", newJString(apiVersion))
  add(query_596930, "$top", newJInt(Top))
  add(query_596930, "$skip", newJInt(Skip))
  add(query_596930, "$filter", newJString(Filter))
  result = call_596929.call(nil, query_596930, nil, nil, nil)

var subscriptionList* = Call_SubscriptionList_596679(name: "subscriptionList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/subscriptions",
    validator: validate_SubscriptionList_596680, base: "",
    url: url_SubscriptionList_596681, schemes: {Scheme.Https})
type
  Call_SubscriptionCreateOrUpdate_597002 = ref object of OpenApiRestCall_596457
proc url_SubscriptionCreateOrUpdate_597004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionCreateOrUpdate_597003(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the subscription of specified user to the specified product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sid` field"
  var valid_597032 = path.getOrDefault("sid")
  valid_597032 = validateParameter(valid_597032, JString, required = true,
                                 default = nil)
  if valid_597032 != nil:
    section.add "sid", valid_597032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   notify: JString
  ##         : Notify the subscriber of the subscription state change to Submitted or Active state.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597033 = query.getOrDefault("api-version")
  valid_597033 = validateParameter(valid_597033, JString, required = true,
                                 default = nil)
  if valid_597033 != nil:
    section.add "api-version", valid_597033
  var valid_597047 = query.getOrDefault("notify")
  valid_597047 = validateParameter(valid_597047, JString, required = false,
                                 default = newJString("False"))
  if valid_597047 != nil:
    section.add "notify", valid_597047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597049: Call_SubscriptionCreateOrUpdate_597002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the subscription of specified user to the specified product.
  ## 
  let valid = call_597049.validator(path, query, header, formData, body)
  let scheme = call_597049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597049.url(scheme.get, call_597049.host, call_597049.base,
                         call_597049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597049, url, valid)

proc call*(call_597050: Call_SubscriptionCreateOrUpdate_597002; apiVersion: string;
          parameters: JsonNode; sid: string; notify: string = "False"): Recallable =
  ## subscriptionCreateOrUpdate
  ## Creates or updates the subscription of specified user to the specified product.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   notify: string
  ##         : Notify the subscriber of the subscription state change to Submitted or Active state.
  var path_597051 = newJObject()
  var query_597052 = newJObject()
  var body_597053 = newJObject()
  add(query_597052, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_597053 = parameters
  add(path_597051, "sid", newJString(sid))
  add(query_597052, "notify", newJString(notify))
  result = call_597050.call(path_597051, query_597052, nil, nil, body_597053)

var subscriptionCreateOrUpdate* = Call_SubscriptionCreateOrUpdate_597002(
    name: "subscriptionCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/subscriptions/{sid}",
    validator: validate_SubscriptionCreateOrUpdate_597003, base: "",
    url: url_SubscriptionCreateOrUpdate_597004, schemes: {Scheme.Https})
type
  Call_SubscriptionGet_596970 = ref object of OpenApiRestCall_596457
proc url_SubscriptionGet_596972(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionGet_596971(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the specified Subscription entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sid` field"
  var valid_596996 = path.getOrDefault("sid")
  valid_596996 = validateParameter(valid_596996, JString, required = true,
                                 default = nil)
  if valid_596996 != nil:
    section.add "sid", valid_596996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596997 = query.getOrDefault("api-version")
  valid_596997 = validateParameter(valid_596997, JString, required = true,
                                 default = nil)
  if valid_596997 != nil:
    section.add "api-version", valid_596997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596998: Call_SubscriptionGet_596970; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Subscription entity.
  ## 
  let valid = call_596998.validator(path, query, header, formData, body)
  let scheme = call_596998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596998.url(scheme.get, call_596998.host, call_596998.base,
                         call_596998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596998, url, valid)

proc call*(call_596999: Call_SubscriptionGet_596970; apiVersion: string; sid: string): Recallable =
  ## subscriptionGet
  ## Gets the specified Subscription entity.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  var path_597000 = newJObject()
  var query_597001 = newJObject()
  add(query_597001, "api-version", newJString(apiVersion))
  add(path_597000, "sid", newJString(sid))
  result = call_596999.call(path_597000, query_597001, nil, nil, nil)

var subscriptionGet* = Call_SubscriptionGet_596970(name: "subscriptionGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/subscriptions/{sid}",
    validator: validate_SubscriptionGet_596971, base: "", url: url_SubscriptionGet_596972,
    schemes: {Scheme.Https})
type
  Call_SubscriptionUpdate_597064 = ref object of OpenApiRestCall_596457
proc url_SubscriptionUpdate_597066(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionUpdate_597065(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Updates the details of a subscription specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sid` field"
  var valid_597067 = path.getOrDefault("sid")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "sid", valid_597067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   notify: JString
  ##         : Notify the subscriber of the subscription state change to Submitted or Active state.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597068 = query.getOrDefault("api-version")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "api-version", valid_597068
  var valid_597069 = query.getOrDefault("notify")
  valid_597069 = validateParameter(valid_597069, JString, required = false,
                                 default = newJString("False"))
  if valid_597069 != nil:
    section.add "notify", valid_597069
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Subscription Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597070 = header.getOrDefault("If-Match")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "If-Match", valid_597070
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_597072: Call_SubscriptionUpdate_597064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of a subscription specified by its identifier.
  ## 
  let valid = call_597072.validator(path, query, header, formData, body)
  let scheme = call_597072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597072.url(scheme.get, call_597072.host, call_597072.base,
                         call_597072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597072, url, valid)

proc call*(call_597073: Call_SubscriptionUpdate_597064; apiVersion: string;
          parameters: JsonNode; sid: string; notify: string = "False"): Recallable =
  ## subscriptionUpdate
  ## Updates the details of a subscription specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  ##   notify: string
  ##         : Notify the subscriber of the subscription state change to Submitted or Active state.
  var path_597074 = newJObject()
  var query_597075 = newJObject()
  var body_597076 = newJObject()
  add(query_597075, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_597076 = parameters
  add(path_597074, "sid", newJString(sid))
  add(query_597075, "notify", newJString(notify))
  result = call_597073.call(path_597074, query_597075, nil, nil, body_597076)

var subscriptionUpdate* = Call_SubscriptionUpdate_597064(
    name: "subscriptionUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/subscriptions/{sid}", validator: validate_SubscriptionUpdate_597065,
    base: "", url: url_SubscriptionUpdate_597066, schemes: {Scheme.Https})
type
  Call_SubscriptionDelete_597054 = ref object of OpenApiRestCall_596457
proc url_SubscriptionDelete_597056(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionDelete_597055(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sid` field"
  var valid_597057 = path.getOrDefault("sid")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "sid", valid_597057
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597058 = query.getOrDefault("api-version")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "api-version", valid_597058
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Subscription Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_597059 = header.getOrDefault("If-Match")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "If-Match", valid_597059
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597060: Call_SubscriptionDelete_597054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified subscription.
  ## 
  let valid = call_597060.validator(path, query, header, formData, body)
  let scheme = call_597060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597060.url(scheme.get, call_597060.host, call_597060.base,
                         call_597060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597060, url, valid)

proc call*(call_597061: Call_SubscriptionDelete_597054; apiVersion: string;
          sid: string): Recallable =
  ## subscriptionDelete
  ## Deletes the specified subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  var path_597062 = newJObject()
  var query_597063 = newJObject()
  add(query_597063, "api-version", newJString(apiVersion))
  add(path_597062, "sid", newJString(sid))
  result = call_597061.call(path_597062, query_597063, nil, nil, nil)

var subscriptionDelete* = Call_SubscriptionDelete_597054(
    name: "subscriptionDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/subscriptions/{sid}", validator: validate_SubscriptionDelete_597055,
    base: "", url: url_SubscriptionDelete_597056, schemes: {Scheme.Https})
type
  Call_SubscriptionRegeneratePrimaryKey_597077 = ref object of OpenApiRestCall_596457
proc url_SubscriptionRegeneratePrimaryKey_597079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid"),
               (kind: ConstantSegment, value: "/regeneratePrimaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionRegeneratePrimaryKey_597078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sid` field"
  var valid_597080 = path.getOrDefault("sid")
  valid_597080 = validateParameter(valid_597080, JString, required = true,
                                 default = nil)
  if valid_597080 != nil:
    section.add "sid", valid_597080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597081 = query.getOrDefault("api-version")
  valid_597081 = validateParameter(valid_597081, JString, required = true,
                                 default = nil)
  if valid_597081 != nil:
    section.add "api-version", valid_597081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597082: Call_SubscriptionRegeneratePrimaryKey_597077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ## 
  let valid = call_597082.validator(path, query, header, formData, body)
  let scheme = call_597082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597082.url(scheme.get, call_597082.host, call_597082.base,
                         call_597082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597082, url, valid)

proc call*(call_597083: Call_SubscriptionRegeneratePrimaryKey_597077;
          apiVersion: string; sid: string): Recallable =
  ## subscriptionRegeneratePrimaryKey
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  var path_597084 = newJObject()
  var query_597085 = newJObject()
  add(query_597085, "api-version", newJString(apiVersion))
  add(path_597084, "sid", newJString(sid))
  result = call_597083.call(path_597084, query_597085, nil, nil, nil)

var subscriptionRegeneratePrimaryKey* = Call_SubscriptionRegeneratePrimaryKey_597077(
    name: "subscriptionRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/subscriptions/{sid}/regeneratePrimaryKey",
    validator: validate_SubscriptionRegeneratePrimaryKey_597078, base: "",
    url: url_SubscriptionRegeneratePrimaryKey_597079, schemes: {Scheme.Https})
type
  Call_SubscriptionRegenerateSecondaryKey_597086 = ref object of OpenApiRestCall_596457
proc url_SubscriptionRegenerateSecondaryKey_597088(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "sid" in path, "`sid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "sid"),
               (kind: ConstantSegment, value: "/regenerateSecondaryKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriptionRegenerateSecondaryKey_597087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sid: JString (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sid` field"
  var valid_597089 = path.getOrDefault("sid")
  valid_597089 = validateParameter(valid_597089, JString, required = true,
                                 default = nil)
  if valid_597089 != nil:
    section.add "sid", valid_597089
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_597090 = query.getOrDefault("api-version")
  valid_597090 = validateParameter(valid_597090, JString, required = true,
                                 default = nil)
  if valid_597090 != nil:
    section.add "api-version", valid_597090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597091: Call_SubscriptionRegenerateSecondaryKey_597086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ## 
  let valid = call_597091.validator(path, query, header, formData, body)
  let scheme = call_597091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597091.url(scheme.get, call_597091.host, call_597091.base,
                         call_597091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597091, url, valid)

proc call*(call_597092: Call_SubscriptionRegenerateSecondaryKey_597086;
          apiVersion: string; sid: string): Recallable =
  ## subscriptionRegenerateSecondaryKey
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  var path_597093 = newJObject()
  var query_597094 = newJObject()
  add(query_597094, "api-version", newJString(apiVersion))
  add(path_597093, "sid", newJString(sid))
  result = call_597092.call(path_597093, query_597094, nil, nil, nil)

var subscriptionRegenerateSecondaryKey* = Call_SubscriptionRegenerateSecondaryKey_597086(
    name: "subscriptionRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/subscriptions/{sid}/regenerateSecondaryKey",
    validator: validate_SubscriptionRegenerateSecondaryKey_597087, base: "",
    url: url_SubscriptionRegenerateSecondaryKey_597088, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
