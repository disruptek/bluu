
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on OpenId Connect Provider entity associated with your Azure API Management deployment. API Management allows you to access APIs secured with token from [OpenID Connect Provider ](http://openid.net/connect/) to be accessed from the Developer Console.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimopenidconnectproviders"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OpenIdConnectProviderList_563777 = ref object of OpenApiRestCall_563555
proc url_OpenIdConnectProviderList_563779(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OpenIdConnectProviderList_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all OpenID Connect Providers.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  var valid_563928 = query.getOrDefault("$top")
  valid_563928 = validateParameter(valid_563928, JInt, required = false, default = nil)
  if valid_563928 != nil:
    section.add "$top", valid_563928
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563929 = query.getOrDefault("api-version")
  valid_563929 = validateParameter(valid_563929, JString, required = true,
                                 default = nil)
  if valid_563929 != nil:
    section.add "api-version", valid_563929
  var valid_563930 = query.getOrDefault("$skip")
  valid_563930 = validateParameter(valid_563930, JInt, required = false, default = nil)
  if valid_563930 != nil:
    section.add "$skip", valid_563930
  var valid_563931 = query.getOrDefault("$filter")
  valid_563931 = validateParameter(valid_563931, JString, required = false,
                                 default = nil)
  if valid_563931 != nil:
    section.add "$filter", valid_563931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563958: Call_OpenIdConnectProviderList_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all OpenID Connect Providers.
  ## 
  let valid = call_563958.validator(path, query, header, formData, body)
  let scheme = call_563958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563958.url(scheme.get, call_563958.host, call_563958.base,
                         call_563958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563958, url, valid)

proc call*(call_564029: Call_OpenIdConnectProviderList_563777; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## openIdConnectProviderList
  ## Lists all OpenID Connect Providers.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field | Supported operators    | Supported functions                         |
  ## 
  ## |-------|------------------------|---------------------------------------------|
  ## | id    | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  ## | name  | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var query_564030 = newJObject()
  add(query_564030, "$top", newJInt(Top))
  add(query_564030, "api-version", newJString(apiVersion))
  add(query_564030, "$skip", newJInt(Skip))
  add(query_564030, "$filter", newJString(Filter))
  result = call_564029.call(nil, query_564030, nil, nil, nil)

var openIdConnectProviderList* = Call_OpenIdConnectProviderList_563777(
    name: "openIdConnectProviderList", meth: HttpMethod.HttpGet,
    host: "azure.local", route: "/openidConnectProviders",
    validator: validate_OpenIdConnectProviderList_563778, base: "",
    url: url_OpenIdConnectProviderList_563779, schemes: {Scheme.Https})
type
  Call_OpenIdConnectProviderCreateOrUpdate_564102 = ref object of OpenApiRestCall_563555
proc url_OpenIdConnectProviderCreateOrUpdate_564104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "opid" in path, "`opid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/openidConnectProviders/"),
               (kind: VariableSegment, value: "opid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OpenIdConnectProviderCreateOrUpdate_564103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the OpenID Connect Provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   opid: JString (required)
  ##       : Identifier of the OpenID Connect Provider.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `opid` field"
  var valid_564122 = path.getOrDefault("opid")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "opid", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
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

proc call*(call_564125: Call_OpenIdConnectProviderCreateOrUpdate_564102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the OpenID Connect Provider.
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_OpenIdConnectProviderCreateOrUpdate_564102;
          apiVersion: string; opid: string; parameters: JsonNode): Recallable =
  ## openIdConnectProviderCreateOrUpdate
  ## Creates or updates the OpenID Connect Provider.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   opid: string (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   parameters: JObject (required)
  ##             : Create parameters.
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  var body_564129 = newJObject()
  add(query_564128, "api-version", newJString(apiVersion))
  add(path_564127, "opid", newJString(opid))
  if parameters != nil:
    body_564129 = parameters
  result = call_564126.call(path_564127, query_564128, nil, nil, body_564129)

var openIdConnectProviderCreateOrUpdate* = Call_OpenIdConnectProviderCreateOrUpdate_564102(
    name: "openIdConnectProviderCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/openidConnectProviders/{opid}",
    validator: validate_OpenIdConnectProviderCreateOrUpdate_564103, base: "",
    url: url_OpenIdConnectProviderCreateOrUpdate_564104, schemes: {Scheme.Https})
type
  Call_OpenIdConnectProviderGet_564070 = ref object of OpenApiRestCall_563555
proc url_OpenIdConnectProviderGet_564072(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "opid" in path, "`opid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/openidConnectProviders/"),
               (kind: VariableSegment, value: "opid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OpenIdConnectProviderGet_564071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets specific OpenID Connect Provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   opid: JString (required)
  ##       : Identifier of the OpenID Connect Provider.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `opid` field"
  var valid_564096 = path.getOrDefault("opid")
  valid_564096 = validateParameter(valid_564096, JString, required = true,
                                 default = nil)
  if valid_564096 != nil:
    section.add "opid", valid_564096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564097 = query.getOrDefault("api-version")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "api-version", valid_564097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564098: Call_OpenIdConnectProviderGet_564070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets specific OpenID Connect Provider.
  ## 
  let valid = call_564098.validator(path, query, header, formData, body)
  let scheme = call_564098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564098.url(scheme.get, call_564098.host, call_564098.base,
                         call_564098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564098, url, valid)

proc call*(call_564099: Call_OpenIdConnectProviderGet_564070; apiVersion: string;
          opid: string): Recallable =
  ## openIdConnectProviderGet
  ## Gets specific OpenID Connect Provider.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   opid: string (required)
  ##       : Identifier of the OpenID Connect Provider.
  var path_564100 = newJObject()
  var query_564101 = newJObject()
  add(query_564101, "api-version", newJString(apiVersion))
  add(path_564100, "opid", newJString(opid))
  result = call_564099.call(path_564100, query_564101, nil, nil, nil)

var openIdConnectProviderGet* = Call_OpenIdConnectProviderGet_564070(
    name: "openIdConnectProviderGet", meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/openidConnectProviders/{opid}",
    validator: validate_OpenIdConnectProviderGet_564071, base: "",
    url: url_OpenIdConnectProviderGet_564072, schemes: {Scheme.Https})
type
  Call_OpenIdConnectProviderUpdate_564140 = ref object of OpenApiRestCall_563555
proc url_OpenIdConnectProviderUpdate_564142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "opid" in path, "`opid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/openidConnectProviders/"),
               (kind: VariableSegment, value: "opid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OpenIdConnectProviderUpdate_564141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specific OpenID Connect Provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   opid: JString (required)
  ##       : Identifier of the OpenID Connect Provider.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `opid` field"
  var valid_564153 = path.getOrDefault("opid")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "opid", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the OpenID Connect Provider to update. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564155 = header.getOrDefault("If-Match")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "If-Match", valid_564155
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

proc call*(call_564157: Call_OpenIdConnectProviderUpdate_564140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specific OpenID Connect Provider.
  ## 
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_OpenIdConnectProviderUpdate_564140;
          apiVersion: string; opid: string; parameters: JsonNode): Recallable =
  ## openIdConnectProviderUpdate
  ## Updates the specific OpenID Connect Provider.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   opid: string (required)
  ##       : Identifier of the OpenID Connect Provider.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_564159 = newJObject()
  var query_564160 = newJObject()
  var body_564161 = newJObject()
  add(query_564160, "api-version", newJString(apiVersion))
  add(path_564159, "opid", newJString(opid))
  if parameters != nil:
    body_564161 = parameters
  result = call_564158.call(path_564159, query_564160, nil, nil, body_564161)

var openIdConnectProviderUpdate* = Call_OpenIdConnectProviderUpdate_564140(
    name: "openIdConnectProviderUpdate", meth: HttpMethod.HttpPatch,
    host: "azure.local", route: "/openidConnectProviders/{opid}",
    validator: validate_OpenIdConnectProviderUpdate_564141, base: "",
    url: url_OpenIdConnectProviderUpdate_564142, schemes: {Scheme.Https})
type
  Call_OpenIdConnectProviderDelete_564130 = ref object of OpenApiRestCall_563555
proc url_OpenIdConnectProviderDelete_564132(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "opid" in path, "`opid` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/openidConnectProviders/"),
               (kind: VariableSegment, value: "opid")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OpenIdConnectProviderDelete_564131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes specific OpenID Connect Provider of the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   opid: JString (required)
  ##       : Identifier of the OpenID Connect Provider.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `opid` field"
  var valid_564133 = path.getOrDefault("opid")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "opid", valid_564133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564134 = query.getOrDefault("api-version")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "api-version", valid_564134
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the OpenID Connect Provider to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564135 = header.getOrDefault("If-Match")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "If-Match", valid_564135
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564136: Call_OpenIdConnectProviderDelete_564130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes specific OpenID Connect Provider of the API Management service instance.
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_OpenIdConnectProviderDelete_564130;
          apiVersion: string; opid: string): Recallable =
  ## openIdConnectProviderDelete
  ## Deletes specific OpenID Connect Provider of the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   opid: string (required)
  ##       : Identifier of the OpenID Connect Provider.
  var path_564138 = newJObject()
  var query_564139 = newJObject()
  add(query_564139, "api-version", newJString(apiVersion))
  add(path_564138, "opid", newJString(opid))
  result = call_564137.call(path_564138, query_564139, nil, nil, nil)

var openIdConnectProviderDelete* = Call_OpenIdConnectProviderDelete_564130(
    name: "openIdConnectProviderDelete", meth: HttpMethod.HttpDelete,
    host: "azure.local", route: "/openidConnectProviders/{opid}",
    validator: validate_OpenIdConnectProviderDelete_564131, base: "",
    url: url_OpenIdConnectProviderDelete_564132, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
