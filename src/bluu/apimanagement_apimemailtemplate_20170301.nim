
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
  macServiceName = "apimanagement-apimemailtemplate"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_EmailTemplateList_563777 = ref object of OpenApiRestCall_563555
proc url_EmailTemplateList_563779(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EmailTemplateList_563778(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists a collection of properties defined within a service instance.
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
  ##          : | Field          | Supported operators    | Supported functions                         |
  ## 
  ## |----------------|------------------------|---------------------------------------------|
  ## | id             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
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

proc call*(call_563958: Call_EmailTemplateList_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists a collection of properties defined within a service instance.
  ## 
  let valid = call_563958.validator(path, query, header, formData, body)
  let scheme = call_563958.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563958.url(scheme.get, call_563958.host, call_563958.base,
                         call_563958.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563958, url, valid)

proc call*(call_564029: Call_EmailTemplateList_563777; apiVersion: string;
          Top: int = 0; Skip: int = 0; Filter: string = ""): Recallable =
  ## emailTemplateList
  ## Lists a collection of properties defined within a service instance.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   Filter: string
  ##         : | Field          | Supported operators    | Supported functions                         |
  ## 
  ## |----------------|------------------------|---------------------------------------------|
  ## | id             | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |
  var query_564030 = newJObject()
  add(query_564030, "$top", newJInt(Top))
  add(query_564030, "api-version", newJString(apiVersion))
  add(query_564030, "$skip", newJInt(Skip))
  add(query_564030, "$filter", newJString(Filter))
  result = call_564029.call(nil, query_564030, nil, nil, nil)

var emailTemplateList* = Call_EmailTemplateList_563777(name: "emailTemplateList",
    meth: HttpMethod.HttpGet, host: "azure.local", route: "/templates",
    validator: validate_EmailTemplateList_563778, base: "",
    url: url_EmailTemplateList_563779, schemes: {Scheme.Https})
type
  Call_EmailTemplateCreateOrUpdate_564115 = ref object of OpenApiRestCall_563555
proc url_EmailTemplateCreateOrUpdate_564117(protocol: Scheme; host: string;
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

proc validate_EmailTemplateCreateOrUpdate_564116(path: JsonNode; query: JsonNode;
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
  var valid_564145 = path.getOrDefault("templateName")
  valid_564145 = validateParameter(valid_564145, JString, required = true, default = newJString(
      "applicationApprovedNotificationMessage"))
  if valid_564145 != nil:
    section.add "templateName", valid_564145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564146 = query.getOrDefault("api-version")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "api-version", valid_564146
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

proc call*(call_564148: Call_EmailTemplateCreateOrUpdate_564115; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an Email Template.
  ## 
  let valid = call_564148.validator(path, query, header, formData, body)
  let scheme = call_564148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564148.url(scheme.get, call_564148.host, call_564148.base,
                         call_564148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564148, url, valid)

proc call*(call_564149: Call_EmailTemplateCreateOrUpdate_564115;
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
  var path_564150 = newJObject()
  var query_564151 = newJObject()
  var body_564152 = newJObject()
  add(query_564151, "api-version", newJString(apiVersion))
  add(path_564150, "templateName", newJString(templateName))
  if parameters != nil:
    body_564152 = parameters
  result = call_564149.call(path_564150, query_564151, nil, nil, body_564152)

var emailTemplateCreateOrUpdate* = Call_EmailTemplateCreateOrUpdate_564115(
    name: "emailTemplateCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "azure.local", route: "/templates/{templateName}",
    validator: validate_EmailTemplateCreateOrUpdate_564116, base: "",
    url: url_EmailTemplateCreateOrUpdate_564117, schemes: {Scheme.Https})
type
  Call_EmailTemplateGet_564070 = ref object of OpenApiRestCall_563555
proc url_EmailTemplateGet_564072(protocol: Scheme; host: string; base: string;
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

proc validate_EmailTemplateGet_564071(path: JsonNode; query: JsonNode;
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
  var valid_564109 = path.getOrDefault("templateName")
  valid_564109 = validateParameter(valid_564109, JString, required = true, default = newJString(
      "applicationApprovedNotificationMessage"))
  if valid_564109 != nil:
    section.add "templateName", valid_564109
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
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

proc call*(call_564111: Call_EmailTemplateGet_564070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the details of the email template specified by its identifier.
  ## 
  let valid = call_564111.validator(path, query, header, formData, body)
  let scheme = call_564111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564111.url(scheme.get, call_564111.host, call_564111.base,
                         call_564111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564111, url, valid)

proc call*(call_564112: Call_EmailTemplateGet_564070; apiVersion: string;
          templateName: string = "applicationApprovedNotificationMessage"): Recallable =
  ## emailTemplateGet
  ## Gets the details of the email template specified by its identifier.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   templateName: string (required)
  ##               : Email Template Name Identifier.
  var path_564113 = newJObject()
  var query_564114 = newJObject()
  add(query_564114, "api-version", newJString(apiVersion))
  add(path_564113, "templateName", newJString(templateName))
  result = call_564112.call(path_564113, query_564114, nil, nil, nil)

var emailTemplateGet* = Call_EmailTemplateGet_564070(name: "emailTemplateGet",
    meth: HttpMethod.HttpGet, host: "azure.local",
    route: "/templates/{templateName}", validator: validate_EmailTemplateGet_564071,
    base: "", url: url_EmailTemplateGet_564072, schemes: {Scheme.Https})
type
  Call_EmailTemplateUpdate_564163 = ref object of OpenApiRestCall_563555
proc url_EmailTemplateUpdate_564165(protocol: Scheme; host: string; base: string;
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

proc validate_EmailTemplateUpdate_564164(path: JsonNode; query: JsonNode;
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
  var valid_564166 = path.getOrDefault("templateName")
  valid_564166 = validateParameter(valid_564166, JString, required = true, default = newJString(
      "applicationApprovedNotificationMessage"))
  if valid_564166 != nil:
    section.add "templateName", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "api-version", valid_564167
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

proc call*(call_564169: Call_EmailTemplateUpdate_564163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specific Email Template.
  ## 
  let valid = call_564169.validator(path, query, header, formData, body)
  let scheme = call_564169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564169.url(scheme.get, call_564169.host, call_564169.base,
                         call_564169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564169, url, valid)

proc call*(call_564170: Call_EmailTemplateUpdate_564163; apiVersion: string;
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
  var path_564171 = newJObject()
  var query_564172 = newJObject()
  var body_564173 = newJObject()
  add(query_564172, "api-version", newJString(apiVersion))
  add(path_564171, "templateName", newJString(templateName))
  if parameters != nil:
    body_564173 = parameters
  result = call_564170.call(path_564171, query_564172, nil, nil, body_564173)

var emailTemplateUpdate* = Call_EmailTemplateUpdate_564163(
    name: "emailTemplateUpdate", meth: HttpMethod.HttpPatch, host: "azure.local",
    route: "/templates/{templateName}", validator: validate_EmailTemplateUpdate_564164,
    base: "", url: url_EmailTemplateUpdate_564165, schemes: {Scheme.Https})
type
  Call_EmailTemplateDelete_564153 = ref object of OpenApiRestCall_563555
proc url_EmailTemplateDelete_564155(protocol: Scheme; host: string; base: string;
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

proc validate_EmailTemplateDelete_564154(path: JsonNode; query: JsonNode;
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
  var valid_564156 = path.getOrDefault("templateName")
  valid_564156 = validateParameter(valid_564156, JString, required = true, default = newJString(
      "applicationApprovedNotificationMessage"))
  if valid_564156 != nil:
    section.add "templateName", valid_564156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564157 = query.getOrDefault("api-version")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "api-version", valid_564157
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString (required)
  ##           : The entity state (Etag) version of the Email Template to delete. A value of "*" can be used for If-Match to unconditionally apply the operation.
  section = newJObject()
  assert header != nil,
        "header argument is necessary due to required `If-Match` field"
  var valid_564158 = header.getOrDefault("If-Match")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "If-Match", valid_564158
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564159: Call_EmailTemplateDelete_564153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reset the Email Template to default template provided by the API Management service instance.
  ## 
  let valid = call_564159.validator(path, query, header, formData, body)
  let scheme = call_564159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564159.url(scheme.get, call_564159.host, call_564159.base,
                         call_564159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564159, url, valid)

proc call*(call_564160: Call_EmailTemplateDelete_564153; apiVersion: string;
          templateName: string = "applicationApprovedNotificationMessage"): Recallable =
  ## emailTemplateDelete
  ## Reset the Email Template to default template provided by the API Management service instance.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   templateName: string (required)
  ##               : Email Template Name Identifier.
  var path_564161 = newJObject()
  var query_564162 = newJObject()
  add(query_564162, "api-version", newJString(apiVersion))
  add(path_564161, "templateName", newJString(templateName))
  result = call_564160.call(path_564161, query_564162, nil, nil, nil)

var emailTemplateDelete* = Call_EmailTemplateDelete_564153(
    name: "emailTemplateDelete", meth: HttpMethod.HttpDelete, host: "azure.local",
    route: "/templates/{templateName}", validator: validate_EmailTemplateDelete_564154,
    base: "", url: url_EmailTemplateDelete_564155, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
