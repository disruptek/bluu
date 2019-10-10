
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2017-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs for performing operations on Email Templates associated with your Azure API Management deployment.
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "apimanagement-apimemailtemplate"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_EmailTemplateList_573879 = ref object of OpenApiRestCall_573657
proc url_EmailTemplateList_573881(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EmailTemplateList_573880(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists a collection of properties defined within a service instance.
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
  ##          : | Field          | Supported operators    | Supported functions                         |
  ## 
  ## |----------------|------------------------|---------------------------------------------|
  ## | id             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574028 = query.getOrDefault("api-version")
  valid_574028 = validateParameter(valid_574028, JString, required = true,
                                 default = nil)
  if valid_574028 != nil:
    section.add "api-version", valid_574028
  var valid_574029 = query.getOrDefault("$top")
  valid_574029 = validateParameter(valid_574029, JInt, required = false, default = nil)
  if valid_574029 != nil:
    section.add "$top", valid_574029
  var valid_574030 = query.getOrDefault("$skip")
  valid_574030 = validateParameter(valid_574030, JInt, required = false, default = nil)
  if valid_574030 != nil:
    section.add "$skip", valid_574030
  var valid_574031 = query.getOrDefault("$filter")
  valid_574031 = validateParameter(valid_574031, JString, required = false,
                                 default = nil)
  if valid_574031 != nil:
    section.add "$filter", valid_574031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574058: Call_EmailTemplateList_573879; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of properties defined within a service instance.
  ## 
  let valid = call_574058.validator(path, query, header, formData, body)
  let scheme = call_574058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574058.url(scheme.get, call_574058.host, call_574058.base,
                         call_574058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574058, url, valid)

proc call*(call_574129: Call_EmailTemplateList_573879; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## emailTemplateList
  ## Lists a collection of properties defined within a service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Top: int
  ##      : Number of records to return.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field          | Supported operators    | Supported functions                         |
  ## 
  ## |----------------|------------------------|---------------------------------------------|
  ## | id             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var query_574130 = newJObject()
  add(query_574130, "api-version", newJString(apiVersion))
  add(query_574130, "$top", newJInt(Top))
  add(query_574130, "$skip", newJInt(Skip))
  add(query_574130, "$filter", newJString(Filter))
  result = call_574129.call(nil, query_574130, nil, nil, nil)

var emailTemplateList* = Call_EmailTemplateList_573879(name: "emailTemplateList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/templates",
    validator: validate_EmailTemplateList_573880, base: "",
    url: url_EmailTemplateList_573881, schemes: {Scheme.Https})
type
  Call_EmailTemplateCreateOrUpdate_574215 = ref object of OpenApiRestCall_573657
proc url_EmailTemplateCreateOrUpdate_574217(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "templateName" in path, "`templateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/templates/"),
               (kind: VariableSegment, value: "templateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EmailTemplateCreateOrUpdate_574216(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an Email Template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   templateName: JString (required)
  ##               : Email Template Name Identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `templateName` field"
  var valid_574245 = path.getOrDefault("templateName")
  valid_574245 = validateParameter(valid_574245, JString, required = true, default = newJString(
      "applicationApprovedNotificationMessage"))
  if valid_574245 != nil:
    section.add "templateName", valid_574245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574246 = query.getOrDefault("api-version")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "api-version", valid_574246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Email Template update parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574248: Call_EmailTemplateCreateOrUpdate_574215; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Email Template.
  ## 
  let valid = call_574248.validator(path, query, header, formData, body)
  let scheme = call_574248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574248.url(scheme.get, call_574248.host, call_574248.base,
                         call_574248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574248, url, valid)

proc call*(call_574249: Call_EmailTemplateCreateOrUpdate_574215;
          apiVersion: string; parameters: JsonNode;
          templateName: string = "applicationApprovedNotificationMessage"): Recallable =
  ## emailTemplateCreateOrUpdate
  ## Updates an Email Template.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   templateName: string (required)
  ##               : Email Template Name Identifier.
  ##   parameters: JObject (required)
  ##             : Email Template update parameters.
  var path_574250 = newJObject()
  var query_574251 = newJObject()
  var body_574252 = newJObject()
  add(query_574251, "api-version", newJString(apiVersion))
  add(path_574250, "templateName", newJString(templateName))
  if parameters != nil:
    body_574252 = parameters
  result = call_574249.call(path_574250, query_574251, nil, nil, body_574252)

var emailTemplateCreateOrUpdate* = Call_EmailTemplateCreateOrUpdate_574215(
    name: "emailTemplateCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/templates/{templateName}",
    validator: validate_EmailTemplateCreateOrUpdate_574216, base: "",
    url: url_EmailTemplateCreateOrUpdate_574217, schemes: {Scheme.Https})
type
  Call_EmailTemplateGet_574170 = ref object of OpenApiRestCall_573657
proc url_EmailTemplateGet_574172(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "templateName" in path, "`templateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/templates/"),
               (kind: VariableSegment, value: "templateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EmailTemplateGet_574171(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the details of the email template specified by its identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   templateName: JString (required)
  ##               : Email Template Name Identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `templateName` field"
  var valid_574209 = path.getOrDefault("templateName")
  valid_574209 = validateParameter(valid_574209, JString, required = true, default = newJString(
      "applicationApprovedNotificationMessage"))
  if valid_574209 != nil:
    section.add "templateName", valid_574209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574210 = query.getOrDefault("api-version")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "api-version", valid_574210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574211: Call_EmailTemplateGet_574170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the email template specified by its identifier.
  ## 
  let valid = call_574211.validator(path, query, header, formData, body)
  let scheme = call_574211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574211.url(scheme.get, call_574211.host, call_574211.base,
                         call_574211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574211, url, valid)

proc call*(call_574212: Call_EmailTemplateGet_574170; apiVersion: string;
          templateName: string = "applicationApprovedNotificationMessage"): Recallable =
  ## emailTemplateGet
  ## Gets the details of the email template specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   templateName: string (required)
  ##               : Email Template Name Identifier.
  var path_574213 = newJObject()
  var query_574214 = newJObject()
  add(query_574214, "api-version", newJString(apiVersion))
  add(path_574213, "templateName", newJString(templateName))
  result = call_574212.call(path_574213, query_574214, nil, nil, nil)

var emailTemplateGet* = Call_EmailTemplateGet_574170(name: "emailTemplateGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/templates/{templateName}", validator: validate_EmailTemplateGet_574171,
    base: "", url: url_EmailTemplateGet_574172, schemes: {Scheme.Https})
type
  Call_EmailTemplateUpdate_574263 = ref object of OpenApiRestCall_573657
proc url_EmailTemplateUpdate_574265(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "templateName" in path, "`templateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/templates/"),
               (kind: VariableSegment, value: "templateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EmailTemplateUpdate_574264(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the specific Email Template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   templateName: JString (required)
  ##               : Email Template Name Identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `templateName` field"
  var valid_574266 = path.getOrDefault("templateName")
  valid_574266 = validateParameter(valid_574266, JString, required = true, default = newJString(
      "applicationApprovedNotificationMessage"))
  if valid_574266 != nil:
    section.add "templateName", valid_574266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574267 = query.getOrDefault("api-version")
  valid_574267 = validateParameter(valid_574267, JString, required = true,
                                 default = nil)
  if valid_574267 != nil:
    section.add "api-version", valid_574267
  result.add "query", section
  section = newJObject()
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

proc call*(call_574269: Call_EmailTemplateUpdate_574263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specific Email Template.
  ## 
  let valid = call_574269.validator(path, query, header, formData, body)
  let scheme = call_574269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574269.url(scheme.get, call_574269.host, call_574269.base,
                         call_574269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574269, url, valid)

proc call*(call_574270: Call_EmailTemplateUpdate_574263; apiVersion: string;
          parameters: JsonNode;
          templateName: string = "applicationApprovedNotificationMessage"): Recallable =
  ## emailTemplateUpdate
  ## Updates the specific Email Template.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   templateName: string (required)
  ##               : Email Template Name Identifier.
  ##   parameters: JObject (required)
  ##             : Update parameters.
  var path_574271 = newJObject()
  var query_574272 = newJObject()
  var body_574273 = newJObject()
  add(query_574272, "api-version", newJString(apiVersion))
  add(path_574271, "templateName", newJString(templateName))
  if parameters != nil:
    body_574273 = parameters
  result = call_574270.call(path_574271, query_574272, nil, nil, body_574273)

var emailTemplateUpdate* = Call_EmailTemplateUpdate_574263(
    name: "emailTemplateUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/templates/{templateName}", validator: validate_EmailTemplateUpdate_574264,
    base: "", url: url_EmailTemplateUpdate_574265, schemes: {Scheme.Https})
type
  Call_EmailTemplateDelete_574253 = ref object of OpenApiRestCall_573657
proc url_EmailTemplateDelete_574255(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "templateName" in path, "`templateName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/templates/"),
               (kind: VariableSegment, value: "templateName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EmailTemplateDelete_574254(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Reset the Email Template to default template provided by the API Management service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   templateName: JString (required)
  ##               : Email Template Name Identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `templateName` field"
  var valid_574256 = path.getOrDefault("templateName")
  valid_574256 = validateParameter(valid_574256, JString, required = true, default = newJString(
      "applicationApprovedNotificationMessage"))
  if valid_574256 != nil:
    section.add "templateName", valid_574256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574257 = query.getOrDefault("api-version")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "api-version", valid_574257
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Email Template to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_574258 = header.getOrDefault("If-Match")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "If-Match", valid_574258
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574259: Call_EmailTemplateDelete_574253; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset the Email Template to default template provided by the API Management service instance.
  ## 
  let valid = call_574259.validator(path, query, header, formData, body)
  let scheme = call_574259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574259.url(scheme.get, call_574259.host, call_574259.base,
                         call_574259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574259, url, valid)

proc call*(call_574260: Call_EmailTemplateDelete_574253; apiVersion: string;
          templateName: string = "applicationApprovedNotificationMessage"): Recallable =
  ## emailTemplateDelete
  ## Reset the Email Template to default template provided by the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   templateName: string (required)
  ##               : Email Template Name Identifier.
  var path_574261 = newJObject()
  var query_574262 = newJObject()
  add(query_574262, "api-version", newJString(apiVersion))
  add(path_574261, "templateName", newJString(templateName))
  result = call_574260.call(path_574261, query_574262, nil, nil, nil)

var emailTemplateDelete* = Call_EmailTemplateDelete_574253(
    name: "emailTemplateDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/templates/{templateName}", validator: validate_EmailTemplateDelete_574254,
    base: "", url: url_EmailTemplateDelete_574255, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
