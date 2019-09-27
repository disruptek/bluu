
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimsubscriptions"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriptionList_593646 = ref object of OpenApiRestCall_593424
proc url_SubscriptionList_593648(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_SubscriptionList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593795 = query.getOrDefault("api-version")
  valid_593795 = validateParameter(valid_593795, JString, required = true,
                                 default = nil)
  if valid_593795 != nil:
    section.add "api-version", valid_593795
  var valid_593796 = query.getOrDefault("$top")
  valid_593796 = validateParameter(valid_593796, JInt, required = false, default = nil)
  if valid_593796 != nil:
    section.add "$top", valid_593796
  var valid_593797 = query.getOrDefault("$skip")
  valid_593797 = validateParameter(valid_593797, JInt, required = false, default = nil)
  if valid_593797 != nil:
    section.add "$skip", valid_593797
  var valid_593798 = query.getOrDefault("$filter")
  valid_593798 = validateParameter(valid_593798, JString, required = false,
                                 default = nil)
  if valid_593798 != nil:
    section.add "$filter", valid_593798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593825: Call_SubscriptionList_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all subscriptions of the API Management service instance.
  ## 
  let valid = call_593825.validator(path, query, header, formData, body)
  let scheme = call_593825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593825.url(scheme.get, call_593825.host, call_593825.base,
                         call_593825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593825, url, valid)

proc call*(call_593896: Call_SubscriptionList_593646; apiVersion: string;
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
  var query_593897 = newJObject()
  add(query_593897, "api-version", newJString(apiVersion))
  add(query_593897, "$top", newJInt(Top))
  add(query_593897, "$skip", newJInt(Skip))
  add(query_593897, "$filter", newJString(Filter))
  result = call_593896.call(nil, query_593897, nil, nil, nil)

var subscriptionList* = Call_SubscriptionList_593646(name: "subscriptionList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/subscriptions",
    validator: validate_SubscriptionList_593647, base: "",
    url: url_SubscriptionList_593648, schemes: {Scheme.Https})
type
  Call_SubscriptionCreateOrUpdate_593969 = ref object of OpenApiRestCall_593424
proc url_SubscriptionCreateOrUpdate_593971(protocol: Scheme; host: string;
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

proc validate_SubscriptionCreateOrUpdate_593970(path: JsonNode; query: JsonNode;
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
  var valid_593999 = path.getOrDefault("sid")
  valid_593999 = validateParameter(valid_593999, JString, required = true,
                                 default = nil)
  if valid_593999 != nil:
    section.add "sid", valid_593999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   notify: JString
  ##         : Notify the subscriber of the subscription state change to Submitted or Active state.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594000 = query.getOrDefault("api-version")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "api-version", valid_594000
  var valid_594014 = query.getOrDefault("notify")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("False"))
  if valid_594014 != nil:
    section.add "notify", valid_594014
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

proc call*(call_594016: Call_SubscriptionCreateOrUpdate_593969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the subscription of specified user to the specified product.
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_SubscriptionCreateOrUpdate_593969; apiVersion: string;
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
  var path_594018 = newJObject()
  var query_594019 = newJObject()
  var body_594020 = newJObject()
  add(query_594019, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594020 = parameters
  add(path_594018, "sid", newJString(sid))
  add(query_594019, "notify", newJString(notify))
  result = call_594017.call(path_594018, query_594019, nil, nil, body_594020)

var subscriptionCreateOrUpdate* = Call_SubscriptionCreateOrUpdate_593969(
    name: "subscriptionCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/subscriptions/{sid}",
    validator: validate_SubscriptionCreateOrUpdate_593970, base: "",
    url: url_SubscriptionCreateOrUpdate_593971, schemes: {Scheme.Https})
type
  Call_SubscriptionGet_593937 = ref object of OpenApiRestCall_593424
proc url_SubscriptionGet_593939(protocol: Scheme; host: string; base: string;
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

proc validate_SubscriptionGet_593938(path: JsonNode; query: JsonNode;
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
  var valid_593963 = path.getOrDefault("sid")
  valid_593963 = validateParameter(valid_593963, JString, required = true,
                                 default = nil)
  if valid_593963 != nil:
    section.add "sid", valid_593963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593964 = query.getOrDefault("api-version")
  valid_593964 = validateParameter(valid_593964, JString, required = true,
                                 default = nil)
  if valid_593964 != nil:
    section.add "api-version", valid_593964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593965: Call_SubscriptionGet_593937; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified Subscription entity.
  ## 
  let valid = call_593965.validator(path, query, header, formData, body)
  let scheme = call_593965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593965.url(scheme.get, call_593965.host, call_593965.base,
                         call_593965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593965, url, valid)

proc call*(call_593966: Call_SubscriptionGet_593937; apiVersion: string; sid: string): Recallable =
  ## subscriptionGet
  ## Gets the specified Subscription entity.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  var path_593967 = newJObject()
  var query_593968 = newJObject()
  add(query_593968, "api-version", newJString(apiVersion))
  add(path_593967, "sid", newJString(sid))
  result = call_593966.call(path_593967, query_593968, nil, nil, nil)

var subscriptionGet* = Call_SubscriptionGet_593937(name: "subscriptionGet",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/subscriptions/{sid}",
    validator: validate_SubscriptionGet_593938, base: "", url: url_SubscriptionGet_593939,
    schemes: {Scheme.Https})
type
  Call_SubscriptionUpdate_594031 = ref object of OpenApiRestCall_593424
proc url_SubscriptionUpdate_594033(protocol: Scheme; host: string; base: string;
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

proc validate_SubscriptionUpdate_594032(path: JsonNode; query: JsonNode;
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
  var valid_594034 = path.getOrDefault("sid")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "sid", valid_594034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   notify: JString
  ##         : Notify the subscriber of the subscription state change to Submitted or Active state.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594035 = query.getOrDefault("api-version")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "api-version", valid_594035
  var valid_594036 = query.getOrDefault("notify")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("False"))
  if valid_594036 != nil:
    section.add "notify", valid_594036
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Subscription Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594037 = header.getOrDefault("If-Match")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "If-Match", valid_594037
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

proc call*(call_594039: Call_SubscriptionUpdate_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of a subscription specified by its identifier.
  ## 
  let valid = call_594039.validator(path, query, header, formData, body)
  let scheme = call_594039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594039.url(scheme.get, call_594039.host, call_594039.base,
                         call_594039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594039, url, valid)

proc call*(call_594040: Call_SubscriptionUpdate_594031; apiVersion: string;
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
  var path_594041 = newJObject()
  var query_594042 = newJObject()
  var body_594043 = newJObject()
  add(query_594042, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_594043 = parameters
  add(path_594041, "sid", newJString(sid))
  add(query_594042, "notify", newJString(notify))
  result = call_594040.call(path_594041, query_594042, nil, nil, body_594043)

var subscriptionUpdate* = Call_SubscriptionUpdate_594031(
    name: "subscriptionUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/subscriptions/{sid}", validator: validate_SubscriptionUpdate_594032,
    base: "", url: url_SubscriptionUpdate_594033, schemes: {Scheme.Https})
type
  Call_SubscriptionDelete_594021 = ref object of OpenApiRestCall_593424
proc url_SubscriptionDelete_594023(protocol: Scheme; host: string; base: string;
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

proc validate_SubscriptionDelete_594022(path: JsonNode; query: JsonNode;
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
  var valid_594024 = path.getOrDefault("sid")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "sid", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : ETag of the Subscription Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_594026 = header.getOrDefault("If-Match")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "If-Match", valid_594026
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594027: Call_SubscriptionDelete_594021; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified subscription.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_SubscriptionDelete_594021; apiVersion: string;
          sid: string): Recallable =
  ## subscriptionDelete
  ## Deletes the specified subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  var path_594029 = newJObject()
  var query_594030 = newJObject()
  add(query_594030, "api-version", newJString(apiVersion))
  add(path_594029, "sid", newJString(sid))
  result = call_594028.call(path_594029, query_594030, nil, nil, nil)

var subscriptionDelete* = Call_SubscriptionDelete_594021(
    name: "subscriptionDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/subscriptions/{sid}", validator: validate_SubscriptionDelete_594022,
    base: "", url: url_SubscriptionDelete_594023, schemes: {Scheme.Https})
type
  Call_SubscriptionRegeneratePrimaryKey_594044 = ref object of OpenApiRestCall_593424
proc url_SubscriptionRegeneratePrimaryKey_594046(protocol: Scheme; host: string;
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

proc validate_SubscriptionRegeneratePrimaryKey_594045(path: JsonNode;
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
  var valid_594047 = path.getOrDefault("sid")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "sid", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594049: Call_SubscriptionRegeneratePrimaryKey_594044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ## 
  let valid = call_594049.validator(path, query, header, formData, body)
  let scheme = call_594049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594049.url(scheme.get, call_594049.host, call_594049.base,
                         call_594049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594049, url, valid)

proc call*(call_594050: Call_SubscriptionRegeneratePrimaryKey_594044;
          apiVersion: string; sid: string): Recallable =
  ## subscriptionRegeneratePrimaryKey
  ## Regenerates primary key of existing subscription of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  var path_594051 = newJObject()
  var query_594052 = newJObject()
  add(query_594052, "api-version", newJString(apiVersion))
  add(path_594051, "sid", newJString(sid))
  result = call_594050.call(path_594051, query_594052, nil, nil, nil)

var subscriptionRegeneratePrimaryKey* = Call_SubscriptionRegeneratePrimaryKey_594044(
    name: "subscriptionRegeneratePrimaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/subscriptions/{sid}/regeneratePrimaryKey",
    validator: validate_SubscriptionRegeneratePrimaryKey_594045, base: "",
    url: url_SubscriptionRegeneratePrimaryKey_594046, schemes: {Scheme.Https})
type
  Call_SubscriptionRegenerateSecondaryKey_594053 = ref object of OpenApiRestCall_593424
proc url_SubscriptionRegenerateSecondaryKey_594055(protocol: Scheme; host: string;
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

proc validate_SubscriptionRegenerateSecondaryKey_594054(path: JsonNode;
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
  var valid_594056 = path.getOrDefault("sid")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "sid", valid_594056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594057 = query.getOrDefault("api-version")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "api-version", valid_594057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594058: Call_SubscriptionRegenerateSecondaryKey_594053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ## 
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_SubscriptionRegenerateSecondaryKey_594053;
          apiVersion: string; sid: string): Recallable =
  ## subscriptionRegenerateSecondaryKey
  ## Regenerates secondary key of existing subscription of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   sid: string (required)
  ##      : Subscription entity Identifier. The entity represents the association between a user and a product in API Management.
  var path_594060 = newJObject()
  var query_594061 = newJObject()
  add(query_594061, "api-version", newJString(apiVersion))
  add(path_594060, "sid", newJString(sid))
  result = call_594059.call(path_594060, query_594061, nil, nil, nil)

var subscriptionRegenerateSecondaryKey* = Call_SubscriptionRegenerateSecondaryKey_594053(
    name: "subscriptionRegenerateSecondaryKey", meth: HttpMethod.HttpPost,
    host: "azure.local", route: "/subscriptions/{sid}/regenerateSecondaryKey",
    validator: validate_SubscriptionRegenerateSecondaryKey_594054, base: "",
    url: url_SubscriptionRegenerateSecondaryKey_594055, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
